//
//  TranPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit
import SceneKit

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
    func removeTransaction(at row: IndexPath)
    func showAddTranVC()
    func chooseTitleForHeader(with section: Int) -> String
    func considerFilter(with category: Bool)
    func goToDetails(with transaction: TranCellEntity, and indexPath: IndexPath)
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
//            if income == Double(Int(income)) {
            self.view!.incomeLabel.text = "+ ₽\(income.removeZerosFromEnd())"
//            } else {
//                self.view!.incomeLabel.text = "+ ₽\(String(format: "%.2f", income))"
//            }
            self.view!.incomeLabel.textColor = .green
            self.view!.incomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
//            if expense == Double(Int(expense)) {
            self.view!.expenseLabel.text = "- ₽\(expense.removeZerosFromEnd())"
//            } else {
//                self.view!.expenseLabel.text = "- ₽\(String(format: "%.2f", expense))"
//            }
            self.view!.expenseLabel.textColor = .red
            self.view!.expenseLabel.font = UIFont.boldSystemFont(ofSize: 22)
        }
    }
    
    func startRefreshingTransactions() {
        interactor?.refreshTransactionsList()
//        DispatchQueue.main.async {
//            self.view?.stateManager?.state = .loading
//        }
    }
    
    func hidePig() {
        view!.blurView.removeFromSuperview()
        view!.scnView.removeFromSuperview()
        let scene = SCNScene(named: "art.scnassets/piggy_bank.obj")!
        let pigNode = scene.rootNode.childNodes.first!
        pigNode.removeAllActions()
    }
    
    func finishRefreshingTransactions() {
        DispatchQueue.main.async {
            self.view!.tableView.reloadData()
            self.hidePig()
            self.view!.refreshControl.endRefreshing()
        }
        updateBalance()
        view!.ind = 0
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
    
    func sortLocalTransactions() {
        view!.localTransactions = view!.localTransactions.sorted {
            // if the dates are equal, sort alphabetically by title
            let calendar = Calendar.current
            let day1 = calendar.component(.day, from: $0.date!)
            let month1 = calendar.component(.month, from: $0.date!)
            let year1 = calendar.component(.year, from: $0.date!)
            let day2 = calendar.component(.day, from: $1.date!)
            let month2 = calendar.component(.month, from: $1.date!)
            let year2 = calendar.component(.year, from: $1.date!)
            if year1 == year2 && month1 == month2 && day1 == day2 {
                // The dates are equal, so sort by title
                return $0.title! > $1.title!
            }
            // otherwise, sort by date
            return $0.date! < $1.date!
        }
    }
    
    func removeTransaction(at indexPath: IndexPath) {
        sortLocalTransactions()
        context.delete(view!.localTransactions[view!.localTranDict[indexPath]!])
        view!.localTransactions.remove(at: view!.localTranDict[indexPath]!)
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
    
    func considerFilter(with category: Bool) {
        if view!.searchText != "" {
            interactor?.applyFilter(with: category)
        }
    }
    
    func goToDetails(with transaction: TranCellEntity, and indexPath: IndexPath) {
        router?.presentTranDetVC(with: transaction, and: indexPath)
    }
}
