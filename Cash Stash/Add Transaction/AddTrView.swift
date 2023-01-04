//
//  AddTrView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import UIKit

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
    var commentTextField: UITextField { get set }
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
    var commentTextField = UITextField()
    @UsesAutoLayout
    var stackView = UIStackView()
//    let realm = try! Realm()
//    var transactions: Results<TransactionData>?
    var transactions = [TransactionData]()
    var categories = [String]()
    var pickerSelection: String?
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ADD TRANSACTION"
        view.backgroundColor = .white
        presenter?.fetchCategoriesFromDefaults()
//        transactions = [TransactionData(context: context)]
        configureStackView()
        configureTextFields()
        configurePickers()
        configureTransactionButton()
//        fetchTransactions()
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).activate()
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).activate()
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).activate()
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).activate()
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(transactionTypePicker)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(commentTextField)
        stackView.addArrangedSubview(categoryPicker)
        stackView.addArrangedSubview(addButton)
    }
    
    func configureTextFields() {
        titleTextField.delegate = self
        amountTextField.delegate = self
        commentTextField.delegate = self
        titleTextField.placeholder = "TITLE"
        titleTextField.borderStyle = .roundedRect
        amountTextField.placeholder = "AMOUNT"
        amountTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "COMMENT(OPTIONAL)"
        commentTextField.borderStyle = .roundedRect
    }
    
    func configurePickers() {
        transactionTypePicker.insertSegment(withTitle: "INCOME", at: 0, animated: true)
        transactionTypePicker.insertSegment(withTitle: "EXPENCE", at: 1, animated: true)
        transactionTypePicker.selectedSegmentIndex = 0
        
//        datePicker.maximumDate = datePicker.date
        datePicker.datePickerMode = .date
        let dateLabel = UILabel()
        dateLabel.text = "DATE: "
        dateStackView.axis = .horizontal
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(datePicker)
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.selectRow((categories.count) / 2, inComponent: 0, animated: true)
    }
    
    func configureTransactionButton() {
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.setTitle("ADD TRANSACTION", for: .normal)
        addButton.backgroundColor = .purple.withAlphaComponent(0.8)
        addButton.layer.cornerRadius = 15
        addButton.heightAnchor.constraint(equalToConstant: 30).activate()
    }
        
    func clearTextFields() {
        titleTextField.text = ""
        amountTextField.text = ""
        commentTextField.text = ""
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
