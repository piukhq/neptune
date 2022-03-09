//
//  FormCollectionViewCell.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import UIKit

protocol FormCollectionViewCellDelegate: AnyObject {
    func formCollectionViewCell(_ cell: FormCollectionViewCell, didSelectField: UITextField)
    func formCollectionViewCell(_ cell: FormCollectionViewCell, shouldResignTextField textField: UITextField)
}

class FormCollectionViewCell: UICollectionViewCell {
    // MARK: - Helpers
    
    private enum Constants {
        static let titleLabelHeight: CGFloat = 20.0
        static let textFieldHeight: CGFloat = 24.0
    }
    
    
    // MARK: - Properties
    
    /// The parent stack view that is pinned to the content view of the cell. Contains all other views.
    private lazy var containerStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fieldContainerVStack, separatorView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        return stackView
    }()
    
    /// The white background visual field view that contains all user interacion elements
    private lazy var fieldContainerVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fieldLabelsVStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.clipsToBounds = true
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: .handleCellTap)
//        stackView.addGestureRecognizer(gestureRecognizer)
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    /// The view that contains the title label and text field
    private lazy var fieldLabelsVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textFieldHStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 00, left: 20, bottom: 7, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
       let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }()
    
    /// The view that contains the text field, camera icon and the validation icon
    private lazy var textFieldHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, validationIconImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight).isActive = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
        field.addTarget(self, action: .textFieldUpdated, for: .editingChanged)
        field.setContentCompressionResistancePriority(.required, for: .vertical)
        field.smartQuotesType = .no // This stops the "smart" apostrophe setting. The default breaks field regex validation
        return field
    }()
    
    lazy var validationIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        imageView.transform = CGAffineTransform(translationX: -4, y: 0)
        imageView.isHidden = true
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    private lazy var inputAccessory: UIToolbar = {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: .accessoryDoneTouchUpInside)
        bar.items = [flexSpace, done]
        bar.sizeToFit()
        return bar
    }()
    
    private weak var formField: FormField?
    private weak var delegate: FormCollectionViewCellDelegate?
    private var pickerSelectedChoice: String?
    private var preferredWidth: CGFloat = 1917 // This has to be a non zero value, chose 300 because of the movie 300.

    // MARK: - Initialisation

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttributes.frame.size.width = preferredWidth
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        return layoutAttributes
    }
    
    // MARK: - Public Methods

    func configure(with field: FormField, delegate: FormCollectionViewCellDelegate?) {
        let isEnabled = !field.isReadOnly
        
        titleLabel.text = field.title
        titleLabel.textColor = isEnabled ? .label : .gray
        textField.textColor = isEnabled ? .label : .gray
        textField.tintColor = .secondaryLabel
        textField.placeholder = field.placeholder
        textField.text = field.forcedValue
        textField.isSecureTextEntry = field.fieldType.isSecureTextEntry
        textField.keyboardType = field.fieldType.keyboardType()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = field.fieldType.capitalization()
        textField.clearButtonMode = field.fieldCommonName == .barcode ? .always : .whileEditing
        textField.accessibilityIdentifier = field.title
        formField = field
        textField.inputAccessoryView = inputAccessory
        
        if case let .expiry(months, years) = field.fieldType {
            textField.inputView = FormMultipleChoiceInput(with: [months, years], delegate: self)
        } else {
            textField.inputView = nil
        }
        
        self.delegate = delegate
        configureStateForFieldValidity(field)
    }
    
    enum ControlState {
        case inactive, active, valid, invalid
    }
    
    private func configureStateForFieldValidity(_ field: FormField) {
        let textfieldIsEmpty = textField.text?.isEmpty ?? false

        if field.isValid() && !textfieldIsEmpty {
            setState(.valid)
        } else if !field.isValid() && !textfieldIsEmpty {
            setState(.invalid)
        } else {
            setState(.inactive)
        }
    }
    
    func setState(_ state: ControlState) {
//        var validationLabelSpacing: CGFloat = validationLabel.isHidden ? 0 : 4
//        var validationIconHidden = true
//
//        switch state {
//        case .inactive:
//            validationView.backgroundColor = .clear
//            validationLabel.isHidden = true
//            validationLabelSpacing = 0
//        case .active:
//            validationView.backgroundColor = .activeField
//        case .valid:
//            validationView.backgroundColor = .validField
//            validationIconHidden = false
//            validationLabelSpacing = 0
//            validationLabel.isHidden = true
//        case .invalid:
//            validationView.backgroundColor = .invalidField
//            validationLabelSpacing = 4
//            validationLabel.isHidden = false
//        }
//
//        guard let field = formField else { return }
//        validationLabel.text = field.validationErrorMessage != nil ? field.validationErrorMessage : L10n.formFieldValidationError
//        isValidationLabelHidden = validationLabel.isHidden
//        validationIconImageView.isHidden = validationIconHidden
//        containerStack.setCustomSpacing(validationLabelSpacing, after: fieldContainerVStack)
    }
    
    // MARK: - Layout
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            containerStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            containerStack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setWidth(_ width: CGFloat) {
        preferredWidth = width
    }
    
    // MARK: - Actions
    
    @objc func textFieldUpdated(_ textField: UITextField, text: String?, backingData: [Int]?) {
        guard let textFieldText = textField.text else { return }
        formField?.updateValue(textFieldText)
//        configureTextFieldRightView(shouldDisplay: textFieldText.isEmpty)
    }
    
    @objc func accessoryDoneTouchUpInside() {
        if let multipleChoiceInput = textField.inputView as? FormMultipleChoiceInput, let textFieldIsEmpty = textField.text?.isEmpty {
            multipleChoiceInputDidUpdate(newValue: textFieldIsEmpty ? "" : multipleChoiceInput.fullContentString, backingData: multipleChoiceInput.backingData)
        }
        
        textField.resignFirstResponder()
        textFieldDidEndEditing(textField)
    }
}

extension FormCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return formField?.textField(textField, shouldChangeInRange: range, newValue: string) ?? false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = formField else { return }
        configureStateForFieldValidity(field)
        field.fieldWasExited()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.inputView?.isKind(of: FormMultipleChoiceInput.self) ?? false || textField.inputView?.isKind(of: UIDatePicker.self) ?? false {
            if let multipleChoiceInput = textField.inputView as? FormMultipleChoiceInput {
                textField.text = (pickerSelectedChoice?.isEmpty ?? false) ? multipleChoiceInput.fullContentString : pickerSelectedChoice
            }
        }
        
//        setState(.active)
        
        self.delegate?.formCollectionViewCell(self, didSelectField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.formCollectionViewCell(self, shouldResignTextField: textField)
        return true
    }
}

extension FormCollectionViewCell: FormMultipleChoiceInputDelegate {
    func multipleChoiceSeparatorForMultiValues() -> String? {
        return "/"
    }
    
    func multipleChoiceInputDidUpdate(newValue: String?, backingData: [Int]?) {
        pickerSelectedChoice = newValue
        formField?.updateValue(newValue)
        textField.text = newValue
        if let options = backingData { formField?.pickerDidSelect(options) }
    }
}

fileprivate extension Selector {
    static let textFieldUpdated = #selector(FormCollectionViewCell.textFieldUpdated(_:text:backingData:))
    static let accessoryDoneTouchUpInside = #selector(FormCollectionViewCell.accessoryDoneTouchUpInside)
}
