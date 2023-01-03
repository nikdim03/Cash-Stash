//
//  TranInteractor.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit
import CoreData

//object
//protocol
//ref to presenter

protocol TranInteractorProtocol {
    var presenter: TranPresenterProtocol? { get set }
    func fetchTransactions(with request: NSFetchRequest<TransactionData>)
    func refreshTransactionsList()
    func applyFilter()
}

class TranInteractor: TranInteractorProtocol {
    var presenter: TranPresenterProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard

    func fetchTransactions(with request: NSFetchRequest<TransactionData>) {
        if presenter?.view!.searchText.count == 0 {
            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", presenter!.view!.fromDate as NSDate, presenter!.view!.uptoDate as NSDate)
        }
        do {
            presenter?.view!.localTransactions = try context.fetch(request)
        } catch {
            print("Error fetching local transactions: \(error)")
        }
    }
    
    func refreshTransactionsList() {
        var localTransactionsModels = makeModels()
        
        Zen.shared.getDiff { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let diffResponse):
                localTransactionsModels.append(contentsOf: self.makeModels(with: diffResponse))
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
        presenter?.view!.sectionedTransactions = groupByDate(transactionCells: localTransactionsModels)
        DispatchQueue.main.async {
            self.presenter?.finishRefreshingTransactions()
        }
    }
        
    func groupByDate(transactionCells: [TransactionCellModel]) -> [Section] {
        let sectionedCells = Dictionary(grouping: transactionCells, by: { (cell) -> Date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let str = formatter.string(from: cell.date)
            return formatter.date(from: str) ?? .distantPast
        }).map {Section(date: $0.key, items: $0.value)}.sorted { $0.date > $1.date }
        return sectionedCells
    }
    
    func updateCategories(with category: String) {
        if category != "" {
            if !presenter!.view!.categories.contains(category) {
                presenter?.view!.categories.append(category)
                defaults.set(presenter?.view!.categories, forKey: "Categories")
            }
        }
    }

    // make transaction cell models fetched from the internet
    func makeModels(with diffResponse: DiffResponse) -> [TransactionCellModel] {
        var transactions = diffResponse.transaction.sorted { $0.date > $1.date }
        transactions = transactions.filter {
            self.updateCategories(with: $0.categories?.first.map { $0.title } ?? "")
            if presenter!.view!.searchText.count > 0 {
                if let amount = Int(presenter!.view!.searchText) {
                    if (Int($0.income) == amount || Int($0.outcome) == amount) && $0.date >= presenter!.view!.fromDate && $0.date <= presenter!.view!.uptoDate {
                        return true
                    }
                } else if $0.payee?.localizedStandardContains(presenter!.view!.searchText) ?? false && $0.date >= presenter!.view!.fromDate && $0.date <= presenter!.view!.uptoDate {
                    return true
                }
                return false
            } else if $0.date >= presenter!.view!.fromDate && $0.date <= presenter!.view!.uptoDate {
                return true
            }
            return false
        }
        return transactions.map { TransactionCellModel(transaction: $0) }
    }
    
    // make transaction cell models fetched from the database
    func makeModels() -> [TransactionCellModel] {
        if presenter?.view!.searchText.count == 0 {
            fetchTransactions(with: TransactionData.fetchRequest())
        }
        var transactionCells = [TransactionCellModel]()
//        localTransactions = [TransactionData(context: context)]
        if presenter!.view!.localTransactions.count > 0 {
            for transaction in presenter!.view!.localTransactions {
                let transactionCell = TransactionCellModel(localTransaction: transaction)
                transactionCells.append(transactionCell)
            }
        }
        return transactionCells
    }
    
    func applyFilter() {
        let request: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
        if let amount = Int(presenter!.view!.searchText) {
            request.predicate = NSPredicate(format: "amount >= %f AND amount < %f AND date >= %@ AND date <= %@", Float(amount), Float(amount + 1), presenter!.view!.fromDatePicker.date as NSDate, presenter!.view!.uptoDatePicker.date as NSDate)
        } else {
            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND title CONTAINS[cd] %@", presenter!.view!.fromDate as NSDate, presenter!.view!.uptoDate as NSDate, presenter!.view!.searchText)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchTransactions(with: request)

//        localTransactions = localTransactions?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "date")
        refreshTransactionsList()
    }
}
