//
//  EdTrPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import Foundation

//object
//protocol
//ref to view, interactor, presenter

protocol EdTrPresenterProtocol {
    var view: EdTrViewProtocol? { get set }
    var interactor: EdTrInteractorProtocol? { get set }
    var router: EdTrRouterProtocol? { get set }
    func processAdd()
    func fetchCategoriesFromDefaults()
}

class EdTrPresenter: EdTrPresenterProtocol {
    var view: EdTrViewProtocol?
    var interactor: EdTrInteractorProtocol?
    var router: EdTrRouterProtocol?
    let defaults = UserDefaults.standard

    func processAdd() {
        interactor?.manageData()
    }
    
    func fetchCategoriesFromDefaults() {
        view?.categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
    }
}
