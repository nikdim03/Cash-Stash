//
//  TranDetPresenter.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import UIKit

//object
//protocol
//ref to view, interactor, presenter

protocol TranDetPresenterProtocol {
    var view: TranDetViewProtocol? { get set }
    var interactor: TranDetInteractorProtocol? { get set }
    var router: TranDetRouterProtocol? { get set }
    func getBubbles() -> [UIView]
    func goToEditView()
}

class TranDetPresenter: TranDetPresenterProtocol {
    var view: TranDetViewProtocol?
    var interactor: TranDetInteractorProtocol?
    var router: TranDetRouterProtocol?
    
    func getBubbles() -> [UIView] {
        let titleBubble = interactor!.createBubble(with: "TITLE", value: view!.tranDetEntity.title)
        let amountBubble = interactor!.createBubble(with: "AMOUNT", value: view!.tranDetEntity.amount)
        let typeBubble = interactor!.createBubble(with: "TYPE", value: view!.tranDetEntity.type)
        let accountBubble = interactor!.createBubble(with: "ACCOUNT", value: view!.tranDetEntity.account ?? "Not specified")
        let categoryBubble = interactor!.createBubble(with: "CATEGORY", value: view!.tranDetEntity.category)
        let commentBubble = interactor!.createBubble(with: "COMMENT", value: view!.tranDetEntity.comment ?? "")
        let dateBubble = interactor!.createBubble(with: "DATE", value: view!.tranDetEntity.date)
//        let coordinatesBubble = interactor!.createBubble(with: "Coordinates", value: tranDetEntity.coordinates)

        return [titleBubble, amountBubble, typeBubble, accountBubble, categoryBubble, commentBubble, dateBubble]
    }
    
    func goToEditView() {
        router?.presentEdTrVC(with: view!.tranDetEntity)
    }
}
