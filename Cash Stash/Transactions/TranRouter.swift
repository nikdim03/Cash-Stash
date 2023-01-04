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
}
