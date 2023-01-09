//
//  AddTrPresenterTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class AddTrPresenterTests: XCTestCase {
    var addTrRouter: AddTrRouterProtocol!
    var addTrPresenter: AddTrPresenterProtocol!
    
    override func setUp() {
        super.setUp()
        addTrRouter = AddTrRouter.start()
        addTrPresenter = addTrRouter.entry!.presenter!
    }
    
    override func tearDown() {
        addTrRouter = AddTrRouter.start()
        addTrPresenter = addTrRouter.entry!.presenter!
        super.tearDown()
    }
    
    func testPresenter() {
        XCTAssertFalse(addTrPresenter.view == nil)
        XCTAssertFalse(addTrPresenter.interactor == nil)
        XCTAssertFalse(addTrPresenter.router == nil)
    }
    
    func testFetchCategoriesFromDefaults() {
        addTrPresenter.fetchCategoriesFromDefaults()
        XCTAssertTrue(addTrPresenter!.view!.categories.count > 0)
    }
}
