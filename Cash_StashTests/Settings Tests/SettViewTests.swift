//
//  SettViewTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/8/23.
//

import XCTest
@testable import Cash_Stash

class SettViewTests: XCTestCase {
    var settView: SettView!
    
    override func setUp() {
        super.setUp()
        settView = SettView()
    }
    
    override func tearDown() {
        settView = nil
        super.tearDown()
    }
    
    func testConfigureTableView() {
        settView.configureTableView()
        XCTAssertTrue(settView.view.subviews.contains(settView.tableView))
        XCTAssertTrue(settView.tableView.delegate is SettView)
        XCTAssertTrue(settView.tableView.dataSource is SettView)
        XCTAssertEqual(settView.tableView.rowHeight, 50)
//        XCTAssertEqual(settView.tableView.reuseIdentifier, "SettingCell")
    }
    
    func testShowLogin() {
        let window = UIWindow()
        window.addSubview(settView.view)
        settView.showLogin()
        let alertController = settView.presentedViewController as? UIAlertController
        XCTAssertNil(alertController?.title)
        XCTAssertNil(alertController?.message)
        XCTAssertEqual(alertController?.preferredStyle, .actionSheet)
        let logInAction = alertController?.actions[0]
        XCTAssertEqual(logInAction?.title, "Log In")
        XCTAssertEqual(logInAction?.style, .default)
//        logInAction?.handler?(logInAction!)
//        XCTAssertTrue(Zen.shared.authCalled)
    }
    
    func testShowLogout() {
        let window = UIWindow()
        window.addSubview(settView.view)
        settView.showLogout()
        let alertController = settView.presentedViewController as? UIAlertController
        XCTAssertNil(alertController?.title)
        XCTAssertNil(alertController?.message)
        XCTAssertEqual(alertController?.preferredStyle, .actionSheet)
        let logOutAction = alertController?.actions[0]
        XCTAssertEqual(logOutAction?.title, "Log Out")
        XCTAssertEqual(logOutAction?.style, .default)
//        logOutAction?.handler?(logOutAction!)
//        XCTAssertTrue(Zen.shared.logoutCalled)
    }
    
    func testShowLanguage() {
        let window = UIWindow()
        window.addSubview(settView.view)
        settView.showLanguage()
        let alertController = settView.presentedViewController as? UIAlertController
        XCTAssertEqual(alertController?.title, "Извинение")
        XCTAssertEqual(alertController?.message, "Здесь могли были быть языковые настройки, но автор обленился и оставил всё на последний момент!")
        XCTAssertEqual(alertController?.preferredStyle, .alert)
        let okAction = alertController?.actions[0]
        XCTAssertEqual(okAction?.title, "OK")
        XCTAssertEqual(okAction?.style, .default)
    }
    
    func testShowCurrency() {
        let window = UIWindow()
        window.addSubview(settView.view)
        settView.showCurrency()
        let alertController = settView.presentedViewController as? UIAlertController
        XCTAssertEqual(alertController?.title, "Извинение")
        XCTAssertEqual(alertController?.message, "Здесь могли были быть настройки валюты, но автор обленился и оставил всё на последний момент!")
        XCTAssertEqual(alertController?.preferredStyle, .alert)
        let okAction = alertController?.actions[0]
        XCTAssertEqual(okAction?.title, "OK")
        XCTAssertEqual(okAction?.style, .default)
    }
    
    func testShowAbout() {
        let window = UIWindow()
        window.addSubview(settView.view)
        settView.showAbout()
        XCTAssertEqual(settView.view.subviews.count, 2)
        let aboutView = settView.view.subviews[1] as? AboutView
        XCTAssertNotNil(aboutView)
        XCTAssertEqual(aboutView?.center, settView.view.center)
        XCTAssertEqual(aboutView?.alpha, 1)
    }
}
