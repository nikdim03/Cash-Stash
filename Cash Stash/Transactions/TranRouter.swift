//
//  TranRouter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit

//object
//entry point
typealias TranEntryPoint = TranViewProtocol & UIViewController

protocol TranRouterProtocol {
    var entry: TranEntryPoint? { get } // view
    static func start() -> TranRouterProtocol
    func presentAddTranVC()
    func presentTranDetVC(with transaction: TranCellEntity, and indexPath: IndexPath)
}

class TranRouter: TranRouterProtocol {
    var entry: TranEntryPoint?
    var view: TranViewProtocol?
    
    static func start() -> TranRouterProtocol {
        let router = TranRouter()
        
        let view = TranView()
        let interactor = TranInteractor()
        let presenter = TranPresenter()

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as TranEntryPoint
        
        return router
    }
    
    func presentAddTranVC() {
        guard let entry = entry else { return }
        let addTrRouter = AddTrRouter.start()
        var addTrView = addTrRouter.entry
        addTrView?.completion = {
            entry.presenter?.startRefreshingTransactions()
        }
        entry.present(addTrView!, animated: true)
    }
    
    func presentTranDetVC(with transaction: TranCellEntity, and indexPath: IndexPath) {
        guard let entry = entry else { return }
        let tranDetRouter = TranDetRouter.start(with: TranDetEntity(fromZen: transaction.fromZen, payee: transaction.payee, amount: transaction.amount, currency: transaction.currency, isIncome: transaction.isIncome, account: transaction.account, category: transaction.category, categoryColor: transaction.categoryColor, categorySymbol: transaction.categorySymbol, comment: transaction.comment, date: transaction.date, coordinates: transaction.coordinates))
        var tranDetView = tranDetRouter.entry
        tranDetView?.deletion = {
            entry.presenter?.removeTransaction(at: indexPath)
        }
        tranDetView?.completion = {
            entry.presenter?.startRefreshingTransactions()
        }
        entry.present(tranDetRouter.entry!, animated: true)
    }
}
