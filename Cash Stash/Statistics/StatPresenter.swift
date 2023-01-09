//
//  StatPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/5/23.
//

import UIKit
import SceneKit

//object
//protocol
//ref to view, chartView, interactor, presenter

protocol StatPresenterProtocol {
    var view: StatViewProtocol? { get set }
    var chartView: ChartViewProtocol? { get set }
    var interactor: StatInteractorProtocol? { get set }
    var router: StatRouterProtocol? { get set }
    func initCategoriesFromDefaults()
    func startRefreshingTransactions(of type: Bool)
    func finishRefreshingTransactions()
    func updateBalance()
    func setPercentage()
    func chooseTitleForHeader(with section: Int) -> String
}

class StatPresenter: StatPresenterProtocol {
    var view: StatViewProtocol?
    var chartView: ChartViewProtocol?
    var interactor: StatInteractorProtocol?
    var router: StatRouterProtocol?
    let defaults = UserDefaults.standard
    
    func initCategoriesFromDefaults() {
        view?.categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
    }
    
    func startRefreshingTransactions(of type: Bool) {
        interactor?.refreshTransactionsList(with: type)
    }
    
    func finishRefreshingTransactions() {
        if !view!.dataFetched {
            view!.dataFetched = true
            view!.firstConfig()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view!.tableView.reloadData()
            (self.chartView as! ChartView).handleTap(UITapGestureRecognizer())
            self.hidePig()
            self.view!.refreshControl.endRefreshing()
        }
        updateBalance()
    }
    
    func hidePig() {
        view!.blurView.removeFromSuperview()
        view!.scnView.removeFromSuperview()
        let scene = SCNScene(named: "art.scnassets/piggy_bank.obj")!
        let pigNode = scene.rootNode.childNodes.first!
        pigNode.removeAllActions()
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
        if income > 0 {
            DispatchQueue.main.async {
                self.view!.incomeExpenseLabel.text = "+ ₽\(income.removeZerosFromEnd())"
                self.view!.incomeExpenseLabel.textColor = .green
                self.view!.incomeExpenseLabel.font = .boldSystemFont(ofSize: 22)
            }
        } else {
            DispatchQueue.main.async {
                self.view!.incomeExpenseLabel.text = "- ₽\(expense.removeZerosFromEnd())"
                self.view!.incomeExpenseLabel.textColor = .red
                self.view!.incomeExpenseLabel.font = .boldSystemFont(ofSize: 22)
            }

        }
    }
    
    func setPercentage() {
        let dict = interactor!.getPercentage()
        for (key, val) in dict.sorted(by: { $0.key < $1.key }) {
            chartView?.categories.append(key)
            chartView?.data.append(val)
        }
        // add colors if needed
        if chartView!.categories.count > chartView!.colors.count {
            for _ in chartView!.categories.count...chartView!.data.count + 3 {
                let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
                chartView?.colors.append(randomColor)
            }
        }
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
}
