//
//  SettInteractorTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/8/23.
//


import XCTest
@testable import Cash_Stash

class SettInteractorTests: XCTestCase {
    var settRouter: SettRouterProtocol!
    var settInteractor: SettInteractorProtocol!
    
    override func setUp() {
        super.setUp()
        settRouter = SettRouter.start()
        settInteractor = settRouter.entry!.presenter!.interactor
    }
    
    override func tearDown() {
        settRouter = SettRouter.start()
        settInteractor = settRouter.entry!.presenter!.interactor
        super.tearDown()
    }
    
    func testPresenter() {
        XCTAssertFalse(settInteractor.presenter == nil)
    }
}
