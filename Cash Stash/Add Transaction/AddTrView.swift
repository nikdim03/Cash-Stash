//
//  AddTrView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import UIKit
import CoreGraphics // for iOS 12 CGColor

//view controller
//protocol
//ref to presenter

//MARK: - AddTrView
protocol AddTrViewProtocol {
    var presenter: AddTrPresenterProtocol? { get set }
    var categories: [String] { get set }
    var titleTextField: UITextField { get set }
    var amountTextField: UITextField { get set }
    var transactionTypePicker: UISegmentedControl { get set }
    var commentTextView: UITextView { get set }
    var datePicker:UIDatePicker { get set }
    var pickerSelection: String? { get set }
    var transactions: [TransactionData] { get set }
    var completion: (() -> Void)? { get set }
    func clearTextFields()
}

class AddTrView: UIViewController, AddTrViewProtocol {
    var presenter: AddTrPresenterProtocol?
    
    @UsesAutoLayout
    var addButton = UIButton()
    @UsesAutoLayout
    var transactionTypePicker = UISegmentedControl()
    @UsesAutoLayout
    var datePicker = UIDatePicker()
    @UsesAutoLayout
    var dateStackView = UIStackView()
    @UsesAutoLayout
    var categoryPicker = UIPickerView()
    @UsesAutoLayout
    var titleTextField = UITextField()
    @UsesAutoLayout
    var amountTextField = UITextField()
    @UsesAutoLayout
    var commentTextView = UITextView()
    @UsesAutoLayout
    var stackView = UIStackView()
    @UsesAutoLayout
    var closeButton = UIButton()

//    let realm = try! Realm()
//    var transactions: Results<TransactionData>?
    var transactions = [TransactionData]()
    var categories = [String]()
    var pickerSelection: String?
    var completion: (() -> Void)?
    
    @objc func closeButtonTapped() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ADD TRANSACTION"
        view.backgroundColor = .white
        presenter?.fetchCategoriesFromDefaults()
        configureCloseButton()
        configureStackView()
        configureTextFields()
        configurePickers()
        configureTransactionButton()
    }
    
    func configureCloseButton() {
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).activate()
        closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).activate()
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor).activate()
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).activate()
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).activate()
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).activate()
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(transactionTypePicker)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(commentTextView)
        stackView.addArrangedSubview(categoryPicker)
        stackView.addArrangedSubview(addButton)
    }
    
    func configureTextFields() {
        titleTextField.delegate = self
        amountTextField.delegate = self
        commentTextView.delegate = self
        titleTextField.placeholder = "TITLE"
        titleTextField.borderStyle = .roundedRect
        amountTextField.placeholder = "AMOUNT"
        amountTextField.borderStyle = .roundedRect
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 7
        commentTextView.text = "COMMENT(OPTIONAL)"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.layer.borderColor = .init(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.9, 0.9, 0.9, 1.0])
        commentTextView.font = .systemFont(ofSize: 17)
        commentTextView.isEditable = true
        commentTextView.isSelectable = true
        commentTextView.isScrollEnabled = true
    }
    
    func configurePickers() {
        transactionTypePicker.insertSegment(withTitle: "INCOME", at: 0, animated: true)
        transactionTypePicker.insertSegment(withTitle: "EXPENSE", at: 1, animated: true)
        transactionTypePicker.selectedSegmentIndex = 0
        
//        datePicker.maximumDate = datePicker.date
        datePicker.datePickerMode = .date
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.text = "DATE: "
        dateStackView.axis = .horizontal
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(datePicker)
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.selectRow(categories.count / 2, inComponent: 0, animated: true)
        pickerSelection = categories[categories.count / 2]
    }
    
    func configureTransactionButton() {
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.setTitle("ADD TRANSACTION", for: .normal)
        addButton.backgroundColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 0.6)
        addButton.layer.cornerRadius = 10
        addButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).activate()
        addButton.heightAnchor.constraint(equalToConstant: 40).activate()
    }
        
    func clearTextFields() {
        titleTextField.text = ""
        amountTextField.text = ""
        commentTextView.text = ""
    }
    
    @objc func addButtonPressed() {
        presenter?.processAdd()
    }
}


//MARK: - AddTrView Extensions
extension AddTrView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = categories[row]
    }
}

extension AddTrView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categories.isEmpty == true {
            categoryPicker.isUserInteractionEnabled = false
        } else {
            categoryPicker.isUserInteractionEnabled = true
        }
        return categories.count
    }
}

extension AddTrView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension AddTrView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "COMMENT(OPTIONAL)"
            textView.textColor = UIColor.lightGray
        }
    }
}
