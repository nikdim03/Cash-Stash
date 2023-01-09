//
//  AddTrInteractorTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class AddTrInteractorTests: XCTestCase {
    var addTrRouter: AddTrRouterProtocol!
    var addTrInteractor: AddTrInteractorProtocol!
    
    override func setUp() {
        super.setUp()
        addTrRouter = AddTrRouter.start()
        addTrInteractor = addTrRouter.entry!.presenter!.interactor
    }
    
    override func tearDown() {
        addTrRouter = AddTrRouter.start()
        addTrInteractor = addTrRouter.entry!.presenter!.interactor
        super.tearDown()
    }
    
    func testFetchTransactions() {
        let addTrInteractor = AddTrInteractor()
        let view = AddTrView()
        let mockPresenter = MockAddTrPresenter()
        mockPresenter.view = view
        addTrInteractor.presenter = mockPresenter
        addTrInteractor.fetchTransactions()
        XCTAssertNotNil(mockPresenter.view!.transactions)
        XCTAssertTrue(mockPresenter.view!.transactions.count > 0)
    }
    
    func testSaveTransaction() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let addTrInteractor = AddTrInteractor()
        let mockPresenter = MockAddTrPresenter()
        let view = AddTrView()
        mockPresenter.view = view
        addTrInteractor.presenter = mockPresenter
        let newTransaction = TransactionData(context: context)
        newTransaction.setValue(true, forKey: "isIncome")
        newTransaction.setValue("Transaction 3", forKey: "title")
        newTransaction.setValue(2, forKey: "amount")
        newTransaction.setValue("com", forKey: "comment")
        newTransaction.setValue(Date(), forKey: "date")
        newTransaction.setValue("cat", forKey: "category")
        addTrInteractor.saveTransaction(transaction: newTransaction)
        XCTAssertEqual(mockPresenter.view!.transactions.last!.title, "Transaction 3")
    }
    
    func testManageDataWithValidInput() {
        let addTrInteractor = AddTrInteractor()
        let view = AddTrView()
        let mockPresenter = MockAddTrPresenter()
        mockPresenter.view = view
        view.categories = ["a", "b", "c"]
        addTrInteractor.presenter = mockPresenter
        mockPresenter.view!.presenter?.fetchCategoriesFromDefaults()
        mockPresenter.view!.titleTextField.text = "Transaction 4"
        mockPresenter.view!.amountTextField.text = "100"
        let expectation = XCTestExpectation(description: "Valid input")
        view.transactions.append(TransactionData())
        view.transactions.append(TransactionData())
        view.transactions.append(TransactionData())
        mockPresenter.view!.completion = {
            expectation.fulfill()
        }
        view.titleTextField.text = "enji"
        view.amountTextField.text = "3"
        view.pickerSelection = "wjktg"
        addTrInteractor.manageData()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockPresenter.view!.transactions.count, 4)
        XCTAssertEqual(mockPresenter.view!.transactions[3].title, "enji")
    }

}

class MockAddTrPresenter: AddTrPresenterProtocol {
    var view: AddTrViewProtocol?
    var interactor: AddTrInteractorProtocol?
    var router: AddTrRouterProtocol?
    let defaults = UserDefaults.standard

    func processAdd() {
        interactor?.manageData()
    }
    
    func fetchCategoriesFromDefaults() {
        view?.categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
    }
}
