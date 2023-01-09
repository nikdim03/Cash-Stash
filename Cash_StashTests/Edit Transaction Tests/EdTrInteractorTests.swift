//
//  EdTrInteractorTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class EdTrInteractorTests: XCTestCase {
    var edTrRouter: EdTrRouterProtocol!
    var edTrInteractor: EdTrInteractorProtocol!
    var initData: InitData!
    
    override func setUp() {
        super.setUp()
        initData = InitData(segInd: 0, title: "Title", amount: "+ ₽20", comment: nil, category: "Groeries", date: "12")

        edTrRouter = EdTrRouter.start(with: initData)
        edTrInteractor = edTrRouter.entry!.presenter!.interactor
    }
    
    override func tearDown() {
        edTrRouter = EdTrRouter.start(with: initData)
        edTrInteractor = edTrRouter.entry!.presenter!.interactor
        super.tearDown()
    }
    
    func testFetchTransactions() {
        let edTrInteractor = EdTrInteractor()
        let view = EdTrView(initData: initData)
        let mockPresenter = MockEdTrPresenter()
        mockPresenter.view = view
        edTrInteractor.presenter = mockPresenter
        edTrInteractor.fetchTransactions()
        XCTAssertNotNil(mockPresenter.view!.transactions)
        XCTAssertTrue(mockPresenter.view!.transactions.count > 0)
    }
    
    func testSaveTransaction() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let edTrInteractor = EdTrInteractor()
        let mockPresenter = MockEdTrPresenter()
        let view = EdTrView(initData: initData)
        mockPresenter.view = view
        edTrInteractor.presenter = mockPresenter
        let newTransaction = TransactionData(context: context)
        newTransaction.setValue(true, forKey: "isIncome")
        newTransaction.setValue("Transaction 3", forKey: "title")
        newTransaction.setValue(2, forKey: "amount")
        newTransaction.setValue("com", forKey: "comment")
        newTransaction.setValue(Date(), forKey: "date")
        newTransaction.setValue("cat", forKey: "category")
        edTrInteractor.saveTransaction(transaction: newTransaction)
        XCTAssertEqual(mockPresenter.view!.transactions.last!.title, "Transaction 3")
    }
    
    func testManageDataWithValidInput() {
        let edTrInteractor = EdTrInteractor()
        let view = EdTrView(initData: initData)
        let mockPresenter = MockEdTrPresenter()
        mockPresenter.view = view
        view.categories = ["a", "b", "c"]
        edTrInteractor.presenter = mockPresenter
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
        edTrInteractor.manageData()
        DispatchQueue.main.async {
            self.wait(for: [expectation], timeout: 10.0)
        }
        XCTAssertEqual(mockPresenter.view!.transactions.count, 4)
        XCTAssertEqual(mockPresenter.view!.transactions[3].title, "enji")
    }

}

class MockEdTrPresenter: EdTrPresenterProtocol {
    var view: EdTrViewProtocol?
    var interactor: EdTrInteractorProtocol?
    var router: EdTrRouterProtocol?
    let defaults = UserDefaults.standard

    func processAdd() {
        interactor?.manageData()
    }
    
    func fetchCategoriesFromDefaults() {
        view?.categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
    }
}
