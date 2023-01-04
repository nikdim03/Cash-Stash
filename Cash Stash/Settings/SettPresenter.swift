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
    var view: SettViewProtocol? { get set }
    var interactor: SettInteractorProtocol? { get set }
    var router: SettRouterProtocol? { get set }
}

class SettPresenter: SettPresenterProtocol {
    var view: SettViewProtocol?
    var interactor: SettInteractorProtocol?
    var router: SettRouterProtocol?
}
