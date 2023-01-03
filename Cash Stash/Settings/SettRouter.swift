//
//  SettRouter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import UIKit

//object
//entry point
typealias SettEntryPoint = SettViewProtocol & UIViewController

protocol SettRouterProtocol {
    var entry: SettEntryPoint? { get } //view
    static func start() -> SettRouterProtocol
}

class SettRouter: SettRouterProtocol {
    var entry: SettEntryPoint?
    var view: SettViewProtocol?
    
    static func start() -> SettRouterProtocol {
        let router = SettRouter()
        
        let view = SettingsVC()
        let interactor = SettInteractor()
        let presenter = SettPresenter()

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as TranEntryPoint
        
        return router
    }
}
