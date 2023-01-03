//
//  TranPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit

//object
//protocol
//ref to view, interactor, presenter

protocol TranPresenterProtocol {
    var view: TranViewProtocol? { get set }
    var interactor: TranInteractorProtocol? { get set }
    var router: TranRouterProtocol? { get set }
    
    func updateBalance()
    func initCategoriesFromDefaults()
    func startRefreshingTransactions()
    func finishRefreshingTransactions()
    func createAlert() -> UIAlertController
    func removeTransaction(at row: Int)
    func showAddTranVC()
    func chooseTitleForHeader(with section: Int) -> String
    func considerFilter()
}

class TranPresenter: TranPresenterProtocol {
    var view: TranViewProtocol?
    var interactor: TranInteractorProtocol?
    var router: TranRouterProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    func initCategoriesFromDefaults() {
        view?.categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
    }
    
    func updateBalance() {
        var income: Double = 0
        var expense: Double = 0
        view!.sectionedTransactions.forEach({ section in
            section.items.forEach { transaction in
                if transaction.isIncome {
                    income += transaction.amount
                } else {
                    expense += transaction.amount
                }
            }
        })
        DispatchQueue.main.async {
            self.view!.incomeLabel.text = "+ ₽\(String(format: "%.2f", income))"
            self.view!.incomeLabel.textColor = .green
            self.view!.expenceLabel.text = "- ₽\(String(format: "%.2f", expense))"
            self.view!.expenceLabel.textColor = .red
        }
    }
    
    func startRefreshingTransactions() {
        view?.stateManager?.state = .loading
        interactor?.refreshTransactionsList()
    }
    
    func finishRefreshingTransactions() {
        view!.stateManager?.state = .loaded
        view!.tableView.reloadData()
        updateBalance()
        view!.refreshControl.endRefreshing()
    }
    
    func createAlert() -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .default)
        let addAction = UIAlertAction(title: "Add category", style: .default) { action in
            self.view?.categories.append(textField.text!)
            self.defaults.set(self.view?.categories, forKey: "Categories")
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(dismissAction)
        alert.addAction(addAction)
        return alert
    }
    
    func removeTransaction(at row: Int) {
        context.delete(view!.localTransactions[row])
        view!.localTransactions.remove(at: row)
        do {
            try context.save()
        } catch {
            print("Error removing local transaction from context: \(error)")
        }
        startRefreshingTransactions()
    }
    
    func showAddTranVC() {
        router?.presentAddTranVC()
    }
    
    func chooseTitleForHeader(with section: Int) -> String {
        let transactionDate = view!.sectionedTransactions[section].date
        if Calendar.current.isDateInYesterday(transactionDate) {
            return "Yesterday"
        } else if Calendar.current.isDateInToday(transactionDate) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(transactionDate) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: transactionDate)
        }
    }
    
    func considerFilter() {
        interactor?.applyFilter()
    }
}
