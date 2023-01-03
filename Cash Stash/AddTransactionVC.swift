//
//  AddTransactionVC.swift
//  Cash Stash
//
//  Created by Dmitriy on 11/8/22.
//

import UIKit
import CoreData
//import RealmSwift

class AddTransactionVC: UIViewController {
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var transactions: Results<TransactionData>?
    var transactions = [TransactionData]()
    let defaults = UserDefaults.standard
    var categories = [String]()
    var pickerSelection: String?
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ADD TRANSACTION"
        view.backgroundColor = .white
        categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
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
    
    func fetchTransactions(with request: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()) {
//        transactions = realm.objects(TransactionData.self)
        do {
            transactions = try context.fetch(request)
        } catch {
            print("Error fetching local transactions: \(error)")
        }
    }
    
    func saveTransaction(transaction: TransactionData) {
//        let entity = NSEntityDescription.entity(forEntityName: "TransactionData", in: context)!
//        let tran = NSManagedObject(entity: entity, insertInto: context)
//        tran.setValue("ggg", forKeyPath: "title")
        do {
            try context.save()
            transactions.append(transaction)
        } catch {
            print("Error saving transaction: \(error)")
        }
        
//        do {
//            try realm.write {
//                realm.add(transaction)
//            }
//        } catch {
//            print("Error on save transaction")
//        }
    }
    
    @objc func addButtonPressed() {
        if titleTextField.text!.count > 14 {
            let alert = UIAlertController(title: "Make your title shorter", message: "Enter a brief title", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if amountTextField.text!.count > 8 {
            let alert = UIAlertController(title: "Amount Too Long", message: "Enter smaller amount", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if titleTextField.text?.isEmpty == false && amountTextField.text?.isEmpty == false {
            let newTransaction = TransactionData(context: context)
            
            if transactionTypePicker.selectedSegmentIndex == 0 {
                newTransaction.setValue(true, forKey: "isIncome")
//                newTransaction.isIncome = true//save differently
            } else {
                newTransaction.setValue(false, forKey: "isIncome")
//                newTransaction.isIncome = false
            }
            newTransaction.setValue(titleTextField.text ?? "No title", forKey: "title")
//            newTransaction.title = titleTextField.text ?? "No title"
            if let amount = Double(amountTextField.text!) {
                newTransaction.setValue(amount, forKey: "amount")
//                newTransaction.amount = amount
            }
            newTransaction.setValue(commentTextField.text, forKey: "comment")
            newTransaction.setValue(datePicker.date, forKey: "date")
            newTransaction.setValue(pickerSelection, forKey: "category")
//            newTransaction.comment = commentTextField.text
//            newTransaction.date = datePicker.date
//            newTransaction.category = pickerSelection
            clearTextFields()
            saveTransaction(transaction: newTransaction)
            completion?()
            self.dismiss(animated: true)
            //            let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            //            self.navigationController?.pushViewController(menuVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Fill in all fields", message: "Please provide correct details", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - UIPickerViewDelegate
extension AddTransactionVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = categories[row]
    }
}

//MARK: - UIPickerViewDataSource
extension AddTransactionVC: UIPickerViewDataSource {
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

//MARK: - UITextFieldDelegate
extension AddTransactionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
