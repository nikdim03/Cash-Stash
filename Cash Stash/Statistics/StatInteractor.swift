//
//  StatInteractor.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/5/23.
//

import UIKit
import CoreData

//object
//protocol
//ref to presenter

protocol StatInteractorProtocol {
    var presenter: StatPresenterProtocol? { get set }
    func refreshTransactionsList(with type: Bool)
    func getPercentage() -> Dictionary<String, Int>
}

class StatInteractor: StatInteractorProtocol {
    var presenter: StatPresenterProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    func fetchTransactions(with request: NSFetchRequest<TransactionData>, type: Bool) {
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND isIncome != %@", presenter!.view!.fromDate as NSDate, presenter!.view!.uptoDate as NSDate, type as NSNumber)
        do {
            presenter?.view!.localTransactions = try context.fetch(request)
        } catch {
            print("Error fetching local transactions: \(error)")
        }
    }
    
    func updateCategories(with category: String) {
        if category != "" {
            if !presenter!.view!.categories.contains(category) {
                presenter?.view!.categories.append(category)
                defaults.set(presenter?.view!.categories, forKey: "Categories")
            }
        }
    }
    
    func groupByDate(transactionCells: [TranCellEntity]) -> [Section] {
        let sectionedCells = Dictionary(grouping: transactionCells, by: { (cell) -> Date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let str = formatter.string(from: cell.date)
            return formatter.date(from: str) ?? .distantPast
        }).map {Section(date: $0.key, items: $0.value)}.sorted { $0.date > $1.date }
        return sectionedCells
    }
    
    // make transaction cell models fetched from the internet
    func makeModels(with diffResponse: DiffResponse, of type: Bool) -> [TranCellEntity] {
        var transactions = diffResponse.transaction.sorted { $0.date > $1.date }
        transactions = transactions.filter {
            self.updateCategories(with: $0.categories?.first.map { $0.title } ?? "")
            if (!type) {
                if $0.date >= presenter!.view!.fromDate && $0.date <= presenter!.view!.uptoDate && $0.income > 0 {
                    return true
                }
            } else {
                if $0.date >= presenter!.view!.fromDate && $0.date <= presenter!.view!.uptoDate && $0.income == 0 {
                    return true
                }
            }
            return false
        }
        return transactions.map { TranCellEntity(transaction: $0) }
    }
    
    // make transaction cell models fetched from the database
    func makeModels(of type: Bool) -> [TranCellEntity] {
        fetchTransactions(with: TransactionData.fetchRequest(), type: type)
        var transactionCells = [TranCellEntity]()
        //        localTransactions = [TransactionData(context: context)]
        if presenter!.view!.localTransactions.count > 0 {
            for transaction in presenter!.view!.localTransactions {
                let transactionCell = TranCellEntity(localTransaction: transaction)
                transactionCells.append(transactionCell)
            }
        }
        return transactionCells
    }
    
    func refreshTransactionsList(with type: Bool) {
        // type = 0 => income, = 1 => expense
        var localTransactionsModels = makeModels(of: type)
        
        Zen.shared.getDiff { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let diffResponse):
                localTransactionsModels.append(contentsOf: self.makeModels(with: diffResponse, of: type))
                self.presenter?.view!.sectionedTransactions = self.groupByDate(transactionCells: localTransactionsModels)
                DispatchQueue.main.async {
                    self.presenter?.finishRefreshingTransactions()
                }
            case .failure(let error):
                print("Error loading transactions from the server: \(error.localizedDescription)")
                //                DispatchQueue.main.async {
                //                    self.refreshControl.endRefreshing()
                //                    self.stateManager?.state = .error(error.localizedDescription)
                //                }
            }
        }
//        presenter?.view!.sectionedTransactions = groupByDate(transactionCells: localTransactionsModels)
//        DispatchQueue.main.async {
//            self.presenter?.finishRefreshingTransactions()
//        }
    }
    
    func getPercentage() -> Dictionary<String, Int> {
        var catCount = 0
        var dict = Dictionary<String, Int>()
        for tran in presenter!.view!.sectionedTransactions {
            for item in tran.items {
                if dict[item.category] == nil {
                    dict.updateValue(0, forKey: item.category)
                }
                dict[item.category]! += 1
            }
        }
        for el in dict {
            catCount += el.value
        }
        var sum = 0
        for (key, value) in dict {
            dict[key] = value * 100 / catCount
            sum += value * 100 / catCount
        }
        if sum < 100 && sum != 0 {
            for tran in presenter!.view!.sectionedTransactions {
                if sum < 100 {
                    for item in tran.items {
                        if sum < 100 {
                            dict[item.category]! += 1
                            sum += 1
                        } else {
                            break
                        }
                    }
                } else {
                    break
                }
            }
        }
        return dict
    }
}
