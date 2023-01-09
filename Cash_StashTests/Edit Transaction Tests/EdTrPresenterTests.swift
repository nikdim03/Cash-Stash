//
//  EdTrPresenterTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class EdTrPresenterTests: XCTestCase {
    var edTrRouter: EdTrRouterProtocol!
    var edTrPresenter: EdTrPresenterProtocol!
    var initData: InitData!
    
    override func setUp() {
        super.setUp()
        initData = InitData(segInd: 0, title: "Title", amount: "+ ₽20", comment: nil, category: "Groeries", date: "12")
        edTrRouter = EdTrRouter.start(with: initData)
        edTrPresenter = edTrRouter.entry!.presenter!
    }
    
    override func tearDown() {
        edTrRouter = EdTrRouter.start(with: initData)
        edTrPresenter = edTrRouter.entry!.presenter!
        super.tearDown()
    }
    
    func testPresenter() {
        XCTAssertFalse(edTrPresenter.view == nil)
        XCTAssertFalse(edTrPresenter.interactor == nil)
        XCTAssertFalse(edTrPresenter.router == nil)
    }
    
    func testFetchCategoriesFromDefaults() {
        edTrPresenter.fetchCategoriesFromDefaults()
        XCTAssertTrue(edTrPresenter!.view!.categories.count > 0)
    }
}
