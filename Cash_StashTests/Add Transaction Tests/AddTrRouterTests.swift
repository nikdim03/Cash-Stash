//
//  AddTrRouterTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//


import XCTest
@testable import Cash_Stash

class AddTrRouterTests: XCTestCase {
    var addTrRouter: AddTrRouter!
    
    override func setUp() {
        super.setUp()
        addTrRouter = AddTrRouter()
    }
    
    override func tearDown() {
        addTrRouter = nil
        super.tearDown()
    }
    
    func testStart() {
        let router = AddTrRouter.start() as! AddTrRouter
        XCTAssertNotNil(router.entry)
        let entry = router.entry as? AddTrView
        XCTAssertNotNil(entry)
        XCTAssertNotNil(entry?.presenter)
        let presenter = entry?.presenter as? AddTrPresenter
        XCTAssertNotNil(presenter)
        XCTAssertTrue(presenter!.view as! UIViewController === entry)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertTrue(presenter!.router as! AddTrRouter === router)
        let interactor = presenter?.interactor as? AddTrInteractor
        XCTAssertNotNil(interactor)
        XCTAssertTrue(interactor!.presenter as! AddTrPresenter === presenter)
    }
}
