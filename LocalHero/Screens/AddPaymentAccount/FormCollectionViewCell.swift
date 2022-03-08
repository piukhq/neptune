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
        let stackView = UIStackView(arrangedSubviews: [fieldContainerVStack])
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
        stackView.backgroundColor = .white
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
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 7, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
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
//        label.font = UIFont.navbarHeaderLine2
//        label.textColor = Current.themeManager.color(for: .text)
        label.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight).isActive = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
//        field.font = UIFont.textFieldInput
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
        imageView.isHidden = false
        return imageView
    }()
    
    private weak var formField: FormField?
    private weak var delegate: FormCollectionViewCellDelegate?
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
        
//        tintColor = .activeField
        titleLabel.text = field.title
        titleLabel.textColor = isEnabled ? .black : .gray
        textField.textColor = isEnabled ? .black : .gray
        textField.text = field.forcedValue
        textField.placeholder = field.placeholder
        textField.isSecureTextEntry = field.fieldType.isSecureTextEntry
        textField.keyboardType = field.fieldType.keyboardType()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = field.fieldType.capitalization()
        textField.clearButtonMode = field.fieldCommonName == .barcode ? .always : .whileEditing
        textField.accessibilityIdentifier = field.title
        formField = field
//        textField.inputAccessoryView = inputAccessory

        
//        if case let .expiry(months, years) = field.fieldType {
//            textField.inputView = FormMultipleChoiceInput(with: [months, years], delegate: self)
//        } else if case let .choice(data) = field.fieldType {
//            textField.inputView = FormMultipleChoiceInput(with: [data], delegate: self)
//            pickerSelectedChoice = data.first?.title
//            formField?.updateValue(pickerSelectedChoice)
//        } else if case .date = field.fieldType {
//            let datePicker = UIDatePicker()
//            datePicker.datePickerMode = .date
//            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
//
//            if #available(iOS 14.0, *) {
//                datePicker.preferredDatePickerStyle = .inline
//                datePicker.backgroundColor = Current.themeManager.color(for: .viewBackground)
//                datePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
//            }
//
//            textField.inputView = datePicker
//            pickerSelectedChoice = datePicker.date.getFormattedString(format: .dayShortMonthYearWithSlash)
//            formField?.updateValue(pickerSelectedChoice)
//        } else {
//            textField.inputView = nil
//        }
        
        self.delegate = delegate
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
//        formField?.updateValue(textFieldText)
//        configureTextFieldRightView(shouldDisplay: textFieldText.isEmpty)
    }
}

extension FormCollectionViewCell: UITextFieldDelegate {
    
}


fileprivate extension Selector {
    static let textFieldUpdated = #selector(FormCollectionViewCell.textFieldUpdated(_:text:backingData:))
}
