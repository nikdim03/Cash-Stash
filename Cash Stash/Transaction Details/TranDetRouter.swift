//
//  TranDetRouter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import UIKit

//object
//entry point
typealias TranDetEntryPoint = TranDetViewProtocol & UIViewController

protocol TranDetRouterProtocol {
    var entry: TranDetEntryPoint? { get } //view
    static func start(with entity: TranDetEntity) -> TranDetRouterProtocol
    func presentEdTrVC(with entity: TranDetEntity)
}

class TranDetRouter: TranDetRouterProtocol {
    var entry: TranDetEntryPoint?
    var view: TranViewProtocol?
    
    static func start(with entity: TranDetEntity) -> TranDetRouterProtocol {
        let router = TranDetRouter()
        
        let view = TranDetView(tranDetEntity: entity)
        let interactor = TranDetInteractor()
        let presenter = TranDetPresenter()

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as TranDetEntryPoint
        
        return router
    }
    
    func presentEdTrVC(with entity: TranDetEntity) {
        guard let entry = entry else { return }
        let edTrRouter = EdTrRouter.start(with: InitData(segInd: entity.type == "INCOME" ? 0 : 1, title: entity.title, amount: entity.amount, comment: entity.comment, category: entity.category, date: entity.date))
        var edTrView = edTrRouter.entry
        edTrView?.deletion = {
            entry.deletion!()
        }
        edTrView?.completion = {
            entry.dismiss(animated: true)
        }
        entry.present(edTrView!, animated: true)
    }
}
