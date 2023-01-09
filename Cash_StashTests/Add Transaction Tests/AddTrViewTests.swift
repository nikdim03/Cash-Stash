//
//  AddTrViewTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class AddTrViewTests: XCTestCase {
    var addTrView: AddTrViewProtocol!
    var addTrRouter: AddTrRouterProtocol!
    
    override func setUp() {
        super.setUp()
        addTrRouter = AddTrRouter.start()
        addTrView = addTrRouter.entry
    }
    
    override func tearDown() {
        addTrView = nil
        super.tearDown()
    }
    
    func testClearTextFields() {
        let addTrView = AddTrView()
        addTrView.titleTextField.text = "Title"
        addTrView.amountTextField.text = "50"
        addTrView.commentTextView.text = "Comment"
        addTrView.clearTextFields()
        XCTAssertEqual(addTrView.titleTextField.text, "")
        XCTAssertEqual(addTrView.amountTextField.text, "")
        XCTAssertEqual(addTrView.commentTextView.text, "")
    }
}
