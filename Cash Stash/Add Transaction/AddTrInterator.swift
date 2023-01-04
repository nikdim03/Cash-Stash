//
//  AddTrInterator.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import UIKit
import CoreData

//object
//protocol
//ref to presenter

protocol AddTrInteractorProtocol {
    var presenter: AddTrPresenterProtocol? { get set }
    func manageData()
}

class AddTrInteractor: AddTrInteractorProtocol {
    var presenter: AddTrPresenterProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchTransactions(with request: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()) {
//        transactions = realm.objects(TransactionData.self)
        do {
            presenter!.view!.transactions = try context.fetch(request)
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
            presenter!.view!.transactions.append(transaction)
        } catch {
            print("Error saving transaction: \(error)")
        }
    }

    func manageData() {
        if presenter!.view!.titleTextField.text!.count > 14 {
            let alert = UIAlertController(title: "Make your title shorter", message: "Enter a brief title", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            (presenter!.view! as! UIViewController).present(alert, animated: true, completion: nil)
        } else if presenter!.view!.amountTextField.text!.count > 8 {
            let alert = UIAlertController(title: "Amount Too Long", message: "Enter smaller amount", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            (presenter!.view! as! UIViewController).present(alert, animated: true, completion: nil)
        } else if presenter!.view!.titleTextField.text?.isEmpty == false && presenter!.view!.amountTextField.text?.isEmpty == false {
            let newTransaction = TransactionData(context: context)
            
            if presenter!.view!.transactionTypePicker.selectedSegmentIndex == 0 {
                newTransaction.setValue(true, forKey: "isIncome")
//                newTransaction.isIncome = true//save differently
            } else {
                newTransaction.setValue(false, forKey: "isIncome")
//                newTransaction.isIncome = false
            }
            newTransaction.setValue(presenter!.view!.titleTextField.text ?? "No title", forKey: "title")
//            newTransaction.title = titleTextField.text ?? "No title"
            if let amount = Double(presenter!.view!.amountTextField.text!) {
                newTransaction.setValue(amount, forKey: "amount")
//                newTransaction.amount = amount
            }
            newTransaction.setValue(presenter!.view!.commentTextField.text, forKey: "comment")
            newTransaction.setValue(presenter!.view!.datePicker.date, forKey: "date")
            newTransaction.setValue(presenter!.view!.pickerSelection, forKey: "category")
//            newTransaction.comment = commentTextField.text
//            newTransaction.date = datePicker.date
//            newTransaction.category = pickerSelection
            presenter!.view!.clearTextFields()
            saveTransaction(transaction: newTransaction)
            presenter!.view!.completion?()
            (presenter!.view! as! UIViewController).dismiss(animated: true)
            //            let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            //            self.navigationController?.pushViewController(menuVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Fill in all fields", message: "Please provide correct details", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            (presenter!.view! as! UIViewController).present(alert, animated: true, completion: nil)
        }
    }
}
