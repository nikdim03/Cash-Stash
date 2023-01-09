//
//  EdTrRouter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import UIKit

//object
//entry point

typealias EdTrEntryPoint = EdTrViewProtocol & UIViewController

protocol EdTrRouterProtocol {
    var entry: EdTrEntryPoint? { get } //view
    static func start(with initData: InitData) -> EdTrRouterProtocol
}

class EdTrRouter: EdTrRouterProtocol {
    var entry: EdTrEntryPoint?
    var view: EdTrViewProtocol?
    
    static func start(with initData: InitData) -> EdTrRouterProtocol {
        let router = EdTrRouter()
        
        let view = EdTrView(initData: initData)
        let interactor = EdTrInteractor()
        let presenter = EdTrPresenter()

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as EdTrEntryPoint
        
        return router
    }
}
