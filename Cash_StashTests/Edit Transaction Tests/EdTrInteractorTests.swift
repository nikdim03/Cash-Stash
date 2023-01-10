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
    var validInitData: InitData!
    var invalidInitData: InitData!
    
    override func setUp() {
        super.setUp()
        validInitData = InitData(segInd: -1, title: "Test Title", amount: "100", comment: "Test Comment", category: "Test Category", date: "Jan 10, 2022 at 5:55 AM")
        invalidInitData = InitData(segInd: -1, title: "Test Title", amount: "100", comment: "Test Comment", category: "Test Category", date: "Jan 10, 2022 at 5:55 AM")
        edTrRouter = EdTrRouter.start(with: validInitData)
        edTrInteractor = edTrRouter.entry!.presenter!.interactor
    }
    
    override func tearDown() {
        edTrRouter = EdTrRouter.start(with: validInitData)
        edTrInteractor = edTrRouter.entry!.presenter!.interactor
        super.tearDown()
    }
    
    func testFetchTransactions() {
        let edTrInteractor = EdTrInteractor()
        let view = EdTrView(initData: validInitData)
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
        let view = EdTrView(initData: validInitData)
        mockPresenter.view = view
        edTrInteractor.presenter = mockPresenter
        let newTransaction = TransactionData(context: context)
        newTransaction.setValue(true, forKey: "isIncome")
        newTransaction.setValue("Test Transaction", forKey: "title")
        newTransaction.setValue(2, forKey: "amount")
        newTransaction.setValue("Test Comment", forKey: "comment")
        newTransaction.setValue(Date(), forKey: "date")
        newTransaction.setValue("Test Category", forKey: "category")
        edTrInteractor.saveTransaction(transaction: newTransaction)
        XCTAssertEqual(mockPresenter.view!.transactions.last!.title, "Test Transaction")
    }
    
    func testManageDataWithValidInput() {
        let edTrInteractor = EdTrInteractor()
        let view = EdTrView(initData: validInitData)
        let mockPresenter = MockEdTrPresenter()
        mockPresenter.view = view
        view.categories = ["a", "b", "c"]
        edTrInteractor.presenter = mockPresenter
        mockPresenter.view!.presenter?.fetchCategoriesFromDefaults()
        mockPresenter.view!.titleTextField.text = "Test Transaction"
        mockPresenter.view!.amountTextField.text = "100"
        let expectation = XCTestExpectation(description: "Valid input")
        view.transactions.append(TransactionData())
        view.transactions.append(TransactionData())
        view.transactions.append(TransactionData())
        mockPresenter.view!.completion = {
            expectation.fulfill()
        }
        view.titleTextField.text = "Last"
        view.amountTextField.text = "100"
        view.pickerSelection = "Some Category"
        edTrInteractor.manageData()
        DispatchQueue.main.async {
            self.wait(for: [expectation], timeout: 10.0)
        }
        XCTAssertEqual(mockPresenter.view!.transactions.count, 4)
        XCTAssertEqual(mockPresenter.view!.transactions.last?.title, "Last")
    }
    
    func testManageDataWithInvalidInput() {
        let edTrInteractor = EdTrInteractor()
        let view = EdTrView(initData: validInitData)
        let mockPresenter = MockEdTrPresenter()
        mockPresenter.view = view
        view.categories = ["a", "b", "c"]
        edTrInteractor.presenter = mockPresenter
        mockPresenter.view!.presenter?.fetchCategoriesFromDefaults()
        mockPresenter.view!.titleTextField.text = "Test Transaction"
        mockPresenter.view!.amountTextField.text = "100"
        let expectation = XCTestExpectation(description: "Invalid input")
        let transaction = TransactionData(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        transaction.title = "Test Transaction"
        view.transactions.append(TransactionData())
        view.transactions.append(TransactionData())
        view.transactions.append(transaction)
        mockPresenter.view!.completion = {
            expectation.fulfill()
        }
        view.titleTextField.text = "Lastagepoijznksvdgoiskgstrdfx;an;kwlzvnkjnsgzsntgxdklgd;vngxtdl;k jdoijpoljrdtovl je[olvdjol hvhr"
        view.amountTextField.text = "100"
        view.pickerSelection = "Some Category"
        edTrInteractor.manageData()
        DispatchQueue.main.async {
            self.wait(for: [expectation], timeout: 10.0)
        }
        XCTAssertEqual(mockPresenter.view!.transactions.count, 3)
        XCTAssertEqual(mockPresenter.view!.transactions.last?.title, "Test Transaction")
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
