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
    var entry: TranEntryPoint? { get } //view
    static func start() -> TranRouterProtocol
    func presentAddTranVC()
}

class TranRouter: TranRouterProtocol {
    var entry: TranEntryPoint?
    var view: TranViewProtocol?
    
    static func start() -> TranRouterProtocol {
        let router = TranRouter()
        
        let view = TransactionsVC()
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
//        let newRouter = RandRouter.createModule()
//        let newViewController = newRouter.view
//        entry.present(newViewController as! UIViewController, animated: true, completion: nil)
        
        // govnocode (replace to the code above when there is router for addTranVC)
        let addTransactionVC = AddTransactionVC()
        addTransactionVC.completion = {
            entry.presenter?.startRefreshingTransactions()
        }
        entry.present(addTransactionVC, animated: true)
    }
}
