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
        // Set up input values
        initData = InitData(segInd: -1, title: "Test Title", amount: "100", comment: "Test Comment", category: "Test Category", date: "Jan 10, 2022 at 5:55 AM")
        edTrRouter = EdTrRouter.start(with: initData)
        edTrView = edTrRouter.entry
    }
    
    override func tearDown() {
        edTrView = nil
        super.tearDown()
    }
    
    func testInitFields() {

        // Initialize mock object
        let mockEdTrView = EdTrView(initData: initData)
        mockEdTrView.initFields()
        // Assert that fields are set correctly
        XCTAssertEqual(mockEdTrView.transactionTypePicker.selectedSegmentIndex, -1)
        XCTAssertEqual(mockEdTrView.titleTextField.text, initData.title)
        XCTAssertEqual(mockEdTrView.amountTextField.text, initData.amount)
        XCTAssertEqual(mockEdTrView.commentTextView.text, initData.comment)
        // Assert that categoryPicker is set correctly
        XCTAssertEqual(mockEdTrView.pickerSelection, initData.category)
        XCTAssertEqual(mockEdTrView.datePicker.date, initData.date)
    }

    func testClearTextFields() {
        let edTrView = EdTrView(initData: initData)
        edTrView.titleTextField.text = "Test Title"
        edTrView.amountTextField.text = "100"
        edTrView.commentTextView.text = "Test Comment"
        edTrView.clearTextFields()
        XCTAssertEqual(edTrView.titleTextField.text, "")
        XCTAssertEqual(edTrView.amountTextField.text, "")
        XCTAssertEqual(edTrView.commentTextView.text, "")
    }
}
