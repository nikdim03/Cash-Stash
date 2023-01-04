//
//  AddTrPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import Foundation

//object
//protocol
//ref to view, interactor, presenter

protocol AddTrPresenterProtocol {
    var view: AddTrViewProtocol? { get set }
    var interactor: AddTrInteractorProtocol? { get set }
    var router: AddTrRouterProtocol? { get set }
    func processAdd()
    func fetchCategoriesFromDefaults()
}

class AddTrPresenter: AddTrPresenterProtocol {
    var view: AddTrViewProtocol?
    var interactor: AddTrInteractorProtocol?
    var router: AddTrRouterProtocol?
    let defaults = UserDefaults.standard

    func processAdd() {
        interactor?.manageData()
    }
    
    func fetchCategoriesFromDefaults() {
        view?.categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
    }
}
