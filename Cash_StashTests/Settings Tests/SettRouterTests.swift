//
//  SettRouterTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class SettRouterTests: XCTestCase {
    var settRouter: SettRouter!
    
    override func setUp() {
        super.setUp()
        settRouter = SettRouter()
    }
    
    override func tearDown() {
        settRouter = nil
        super.tearDown()
    }
    
    func testStart() {
        let router = SettRouter.start() as! SettRouter
        XCTAssertNotNil(router.entry)
        let entry = router.entry as? SettView
        XCTAssertNotNil(entry)
        XCTAssertNotNil(entry?.presenter)
        let presenter = entry?.presenter as? SettPresenter
        XCTAssertNotNil(presenter)
        XCTAssertTrue(presenter!.view as! UIViewController === entry)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertTrue(presenter!.router as! SettRouter === router)
        let interactor = presenter?.interactor as? SettInteractor
        XCTAssertNotNil(interactor)
        XCTAssertTrue(interactor!.presenter as! SettPresenter === presenter)
    }
}
