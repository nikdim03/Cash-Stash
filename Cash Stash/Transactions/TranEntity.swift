//
//  TranEntity.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit
import MapKit

struct Section {
    let date: Date
    let items: [TransactionCellModel]
}

struct TransactionCellModel {
    let amount: Double
    let isIncome: Bool
    let date: Date
    let currency: String
    var category: String
    let account: String
    let payee: String
    let categorySymbol: UIImage
    let categoryColor: UIColor
    let comment: String
    let coordinates: CLLocationCoordinate2D?

    init(transaction: Transaction) {
        date = transaction.date
        category = transaction.categories?.first.map { $0.title } ?? ""
        payee = transaction.payee ?? "No Content"
        isIncome = transaction.income > 0 ? true : false
        comment = transaction.comment ?? ""
        if let latitude = transaction.latitude, let longitude = transaction.longitude {
            coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinates = nil
        }
        if let categoryIconString = transaction.categories?.first?.icon,
           let image = UIImage.expenceCategory(named: categoryIconString) {
            categorySymbol = image
            let categoryHash = Int(categoryIconString.hash / 10000000)

            srand48(categoryHash * 200)
            let red = CGFloat(drand48())

            srand48(categoryHash)
            let green = CGFloat(drand48())

            srand48(categoryHash / 200)
            let blue = CGFloat(drand48())
            
            categoryColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        } else {
            categorySymbol = UIImage(named: "questionmark")!
            categoryColor = .black
        }

        if transaction.income == 0 {
            amount = transaction.outcome
            currency = transaction.outcomeTransactionInstrument?.symbol ?? ""
            account = transaction.fromAccount?.title ?? ""
        } else {
            amount = transaction.income
            currency = transaction.incomeTransactionInstrument?.symbol ?? ""
            account = transaction.fromAccount?.title ?? ""
        }
    }
    
    init(localTransaction: TransactionData) {
        date = localTransaction.date!
        category = localTransaction.category ?? "Not specified"
        payee = localTransaction.title!
        comment = localTransaction.comment ?? ""
        coordinates = nil
        categorySymbol = UIImage(named: "questionmark")!
        categoryColor = .black
        amount = localTransaction.amount
        isIncome = localTransaction.isIncome
        currency = "₽"
        account = "Not specified"
    }
}
