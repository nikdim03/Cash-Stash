//
//  SettInteractor.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/4/23.
//

import Foundation

//object
//protocol
//ref to presenter

protocol SettInteractorProtocol {
    var presenter: SettPresenterProtocol? { get set }
}

class SettInteractor: SettInteractorProtocol {
    var presenter: SettPresenterProtocol?
}
