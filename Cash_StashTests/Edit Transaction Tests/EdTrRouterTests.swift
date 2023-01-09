//
//  EdTrRouterTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class EdTrRouterTests: XCTestCase {
    var edTrRouter: EdTrRouter!
    var initData: InitData!
    
    override func setUp() {
        super.setUp()
        initData = InitData(segInd: 0, title: "Title", amount: "+ ₽20", comment: nil, category: "Groeries", date: "12")
        edTrRouter = EdTrRouter()
    }
    
    override func tearDown() {
        edTrRouter = nil
        super.tearDown()
    }
    
    func testStart() {
        let router = EdTrRouter.start(with: initData) as! EdTrRouter
        XCTAssertNotNil(router.entry)
        let entry = router.entry as? EdTrView
        XCTAssertNotNil(entry)
        XCTAssertNotNil(entry?.presenter)
        let presenter = entry?.presenter as? EdTrPresenter
        XCTAssertNotNil(presenter)
        XCTAssertTrue(presenter!.view as! UIViewController === entry)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertTrue(presenter!.router as! EdTrRouter === router)
        let interactor = presenter?.interactor as? EdTrInteractor
        XCTAssertNotNil(interactor)
        XCTAssertTrue(interactor!.presenter as! EdTrPresenter === presenter)
    }
}
