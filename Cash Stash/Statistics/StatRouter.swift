//
//  StatRouter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/5/23.
//

import UIKit

//object
//entry point
typealias StatEntryPoint = StatViewProtocol & UIViewController

protocol StatRouterProtocol {
    var entry: StatEntryPoint? { get } //view
    static func start() -> StatRouterProtocol
}

class StatRouter: StatRouterProtocol {
    var entry: StatEntryPoint?
    var view: StatViewProtocol?
    
    static func start() -> StatRouterProtocol {
        let router = StatRouter()
        
        let chartView = ChartView()
        let view = StatView()
        let interactor = StatInteractor()
        let presenter = StatPresenter()

        chartView.presenter = presenter
        
        view.presenter = presenter
        view.chartView = chartView
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.chartView = chartView
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as StatEntryPoint
        
        return router
    }
}
