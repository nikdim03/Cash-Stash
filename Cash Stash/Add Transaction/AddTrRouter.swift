//
//  AddTrRouter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import UIKit

//object
//entry point

typealias AddTrEntryPoint = AddTrViewProtocol & UIViewController

protocol AddTrRouterProtocol {
    var entry: AddTrEntryPoint? { get } //view
    static func start() -> AddTrRouterProtocol
}

class AddTrRouter: AddTrRouterProtocol {
    var entry: AddTrEntryPoint?
    var view: AddTrViewProtocol?
    
    static func start() -> AddTrRouterProtocol {
        let router = AddTrRouter()
        
        let view = AddTrView()
        let interactor = AddTrInteractor()
        let presenter = AddTrPresenter()

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as AddTrEntryPoint
        
        return router
    }
}
