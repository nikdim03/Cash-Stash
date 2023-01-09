//
//  SettPresenterTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/8/23.
//

import XCTest
@testable import Cash_Stash

class SettPresenterTests: XCTestCase {
    var settRouter: SettRouterProtocol!
    var settPresenter: SettPresenterProtocol!
    
    override func setUp() {
        super.setUp()
        settRouter = SettRouter.start()
        settPresenter = settRouter.entry!.presenter!
    }
    
    override func tearDown() {
        settRouter = SettRouter.start()
        settPresenter = settRouter.entry!.presenter!
        super.tearDown()
    }
    
    func testPresenter() {
        XCTAssertFalse(settPresenter.view == nil)
        XCTAssertFalse(settPresenter.interactor == nil)
        XCTAssertFalse(settPresenter.router == nil)
    }
}
