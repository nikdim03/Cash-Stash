//
//  EdTrViewTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class EdTrViewTests: XCTestCase {
    var edTrView: EdTrViewProtocol!
    var edTrRouter: EdTrRouterProtocol!
    var initData: InitData!
    
    override func setUp() {
        super.setUp()
        initData = InitData(segInd: 0, title: "Title", amount: "+ ₽20", comment: nil, category: "Groeries", date: "12")
        edTrRouter = EdTrRouter.start(with: initData)
        edTrView = edTrRouter.entry
    }
    
    override func tearDown() {
        edTrView = nil
        super.tearDown()
    }
    
    func testClearTextFields() {
        let edTrView = EdTrView(initData: initData)
        edTrView.titleTextField.text = "Title"
        edTrView.amountTextField.text = "50"
        edTrView.commentTextView.text = "Comment"
        edTrView.clearTextFields()
        XCTAssertEqual(edTrView.titleTextField.text, "")
        XCTAssertEqual(edTrView.amountTextField.text, "")
        XCTAssertEqual(edTrView.commentTextView.text, "")
    }
}
