//
//  SettPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import Foundation

//object
//protocol
//ref to view, interactor, presenter

protocol SettPresenterProtocol {
    var view: TranViewProtocol? { get set }
    var interactor: TranInteractorProtocol? { get set }
    var router: TranRouterProtocol? { get set }
}

class SettPresenter: SettPresenterProtocol {
    var view: TranViewProtocol?
    var interactor: TranInteractorProtocol?
    var router: TranRouterProtocol?
    
}
