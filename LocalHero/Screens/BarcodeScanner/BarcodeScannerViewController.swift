//
//  BarcodeScannerViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import UIKit
import AVFoundation
import Vision

struct BarcodeScannerViewModel {
    var isScanning = false
}

protocol BarcodeScannerViewControllerDelegate: AnyObject {
    func barcodeScannerViewController(_ viewController: BarcodeScannerViewController, didScanBarcode barcode: String, completion: (() -> Void)?)
}

class BarcodeScannerViewController: LocalHeroViewController, UINavigationControllerDelegate {
    enum Constants {
        static let rectOfInterestInset: CGFloat = 25
        static let viewFrameRatio: CGFloat = 12 / 18
        static let maskedAreaY: CGFloat = 100
        static let maskedAreaCornerRadius: CGFloat = 8
        static let guideImageInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let explainerLabelPadding: CGFloat = 25
        static let explainerLabelHeight: CGFloat = 22
        static let widgetViewTopPadding: CGFloat = 30
        static let widgetViewLeftRightPadding: CGFloat = 25
        static let widgetViewHeight: CGFloat = 100
        static let closeButtonSize = CGSize(width: 44, height: 44)
        static let timerInterval: TimeInterval = 5.0
        static let scanErrorThreshold: TimeInterval = 1.0
    }
    
    enum ScannerType {
        case login
        case loyalty
    }

    private weak var delegate: BarcodeScannerViewControllerDelegate?

    private var session = AVCaptureSession()
    private var captureOutput: AVCaptureMetadataOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var visionUtility = VisionImageDetectionUtility()
    private var previewView = UIView()
    private let schemeScanningQueue = DispatchQueue(label: "com.bink.localhero.scanning.loyalty.scheme.queue")
    private var rectOfInterest = CGRect.zero
    private var timer: Timer?
    private var canPresentScanError = true
    private var hideNavigationBar = true
    private var shouldAllowScanning = true

    private lazy var blurredView: UIVisualEffectView = {
        return UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    }()

    private lazy var guideImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.scannerGuide.image)
        return imageView
    }()

    private lazy var explainerLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.barcodeScannerExplainerLabelLogin
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var widgetView: BarcodeScannerWidgetView = {
        let widget = BarcodeScannerWidgetView()
        widget.addTarget(self, selector: #selector(enterManually))
        widget.translatesAutoresizingMaskIntoConstraints = false
        return widget
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Asset.close.image, for: .normal)
        button.imageView?.tintColor = .systemPurple
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    private lazy var addFromPhotoLibraryButton: BinkButton = {
        return BinkButton(type: .plain, title: L10n.barcodeScannerAddFromPhotoLibraryButtonTitle, action: toPhotoLibrary)
    }()
    
    private var viewModel: BarcodeScannerViewModel

    init(viewModel: BarcodeScannerViewModel, hideNavigationBar: Bool = true, delegate: BarcodeScannerViewControllerDelegate?) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.hideNavigationBar = hideNavigationBar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: false)

            view.addSubview(cancelButton)
            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
                cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4),
                cancelButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize.height),
                cancelButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize.width)
            ])
        }

        if !viewModel.isScanning {
            startScanning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopScanning()
    }
    
    
    private func configureLayout() {
        view.addSubview(previewView)

        // BLUR AND MASK
        blurredView.frame = view.frame
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.frame
        // Setup rect of interest
        let inset = Constants.rectOfInterestInset
        let width = view.frame.size.width - (inset * 2)
        let viewFrameRatio = Constants.viewFrameRatio
        let height: CGFloat = floor(viewFrameRatio * width)
        let maskedAreaFrame = CGRect(x: inset, y: Constants.maskedAreaY, width: width, height: height)
        rectOfInterest = maskedAreaFrame
        let maskedPath = UIBezierPath(roundedRect: rectOfInterest, cornerRadius: Constants.maskedAreaCornerRadius)
        maskedPath.append(UIBezierPath(rect: view.bounds))
        maskLayer.fillRule = .evenOdd
        maskLayer.path = maskedPath.cgPath
        blurredView.layer.mask = maskLayer
        view.addSubview(blurredView)
        
        guideImageView.frame = rectOfInterest.inset(by: Constants.guideImageInset)
        view.addSubview(guideImageView)
        view.addSubview(explainerLabel)
        view.addSubview(widgetView)
        
        if Configuration.isDebug() {
            footerButtons = [addFromPhotoLibraryButton]
        }
        
        NSLayoutConstraint.activate([
            explainerLabel.topAnchor.constraint(equalTo: guideImageView.bottomAnchor, constant: Constants.explainerLabelPadding),
            explainerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.explainerLabelPadding),
            explainerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.explainerLabelPadding),
            explainerLabel.heightAnchor.constraint(equalToConstant: Constants.explainerLabelHeight),
            widgetView.topAnchor.constraint(equalTo: explainerLabel.bottomAnchor, constant: Constants.widgetViewTopPadding),
            widgetView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.widgetViewLeftRightPadding),
            widgetView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.widgetViewLeftRightPadding),
            widgetView.heightAnchor.constraint(equalToConstant: Constants.widgetViewHeight)
        ])
    }

    private func startScanning() {
        viewModel.isScanning = true
        session.sessionPreset = .high
        guard let backCamera = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
        performCaptureChecksForDevice(backCamera)
        captureOutput = AVCaptureMetadataOutput()

        if session.canAddInput(input) {
            session.addInput(input)
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        guard let videoPreviewLayer = videoPreviewLayer else { return }
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait

        previewView.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = view.frame

        guard let captureOutput = captureOutput else { return }

        if session.outputs.isEmpty {
            if session.canAddOutput(captureOutput) {
                session.addOutput(captureOutput)
                captureOutput.setMetadataObjectsDelegate(self, queue: schemeScanningQueue)
                captureOutput.metadataObjectTypes = [
                    .qr,
                    .code128,
                    .aztec,
                    .pdf417,
                    .ean13,
                    .dataMatrix,
                    .interleaved2of5,
                    .code39
                ]
            }
        }

        if !session.isRunning {
            session.startRunning()
        }

        captureOutput.rectOfInterest = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }

    private func stopScanning() {
        viewModel.isScanning = false
        schemeScanningQueue.async { [weak self] in
            self?.session.stopRunning()
            guard let outputs = self?.session.outputs else { return }
            for output in outputs {
                self?.session.removeOutput(output)
            }
            self?.timer?.invalidate()
        }
    }

    private func performCaptureChecksForDevice(_ device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
        } catch {
            // TODO: Handle error
            print(error.localizedDescription)
        }

        if device.isFocusModeSupported(.continuousAutoFocus) {
            device.focusMode = .continuousAutoFocus
        }

        if device.isSmoothAutoFocusSupported {
            device.isSmoothAutoFocusEnabled = true
        }

        device.isSubjectAreaChangeMonitoringEnabled = true

        if device.isFocusPointOfInterestSupported {
            device.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
        }

        if device.isAutoFocusRangeRestrictionSupported {
            device.autoFocusRangeRestriction = .near
        }

        if device.isLowLightBoostSupported {
            device.automaticallyEnablesLowLightBoostWhenAvailable = true
        }

        device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 10)
        device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 10)
        device.unlockForConfiguration()
    }

    @objc private func close() {
        dismiss(animated: true)
    }
    
    @objc private func enterManually() {
        widgetView.animateOnTap()
        let alertController = ViewControllerFactory.makeAlertViewControllerWithTextfield(title: L10n.barcodeScannerWidgetTitleEnterManuallyText, message: L10n.barcodeScannerEnterManullyAlertDescription) { [weak self] textfieldText in
            self?.passDataToBarcodeScannerDelegate(barcode: textfieldText)
        }
        let navigationRequest = AlertNavigationRequest(alertController: alertController)
        Current.navigate.to(navigationRequest)
    }
    
    private func toPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        let navigationRequest = ModalNavigationRequest(viewController: picker, embedInNavigationController: false)
        Current.navigate.to(navigationRequest)
    }
    

    private func passDataToBarcodeScannerDelegate(barcode: String) {
        self.stopScanning()
        HapticFeedbackUtil.giveFeedback(forType: .notification(type: .success))

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            Current.navigate.close(animated: true) {
                self.delegate?.barcodeScannerViewController(self, didScanBarcode: barcode, completion: nil)
            }
        }
    }
    
    private func showError() {
        let alert = ViewControllerFactory.makeAlertController(title: L10n.error, message: L10n.barcodeScannerErrorMessageFailedToDetectLoginToken) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.scanErrorThreshold, execute: {
                self.canPresentScanError = true
                self.shouldAllowScanning = true
            })
        }
        
        let navigationRequest = AlertNavigationRequest(alertController: alert)
        Current.navigate.to(navigationRequest)
    }
}

extension BarcodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        timer?.invalidate()
        guard shouldAllowScanning else { return }
        shouldAllowScanning = false

        if let object = metadataObjects.first {
            guard let readableObject = object as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            passDataToBarcodeScannerDelegate(barcode: stringValue)
        }
    }
}

// MARK: - Detect barcode from image

extension BarcodeScannerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        Current.navigate.close(animated: true) { [weak self] in
            self?.visionUtility.createVisionRequest(image: image) { barcode in
                guard let barcode = barcode else {
                    self?.showError()
                    return
                }
                self?.passDataToBarcodeScannerDelegate(barcode: barcode)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        Current.navigate.close(animated: true)
    }
}
