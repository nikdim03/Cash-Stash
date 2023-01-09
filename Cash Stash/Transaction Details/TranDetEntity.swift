//
//  TranDetEntity.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import Foundation
import MapKit

class TranDetEntity {
    let fromZen: Bool
    let title: String
    let amount: String
    let type: String
    let account: String?
    let category: String
    let categoryColor: UIColor?
    let categorySymbol: UIImage?
    let comment: String?
    let date: String
    let coordinates: CLLocationCoordinate2D?
    
    init(fromZen: Bool, payee: String, amount: Double, currency: String, isIncome: Bool, account: String, category: String, categoryColor: UIColor, categorySymbol: UIImage, comment: String?, date: Date, coordinates: CLLocationCoordinate2D?) {
        self.fromZen = fromZen
        self.title = payee
        self.amount = currency == "руб." ? "₽" + "\(amount.removeZerosFromEnd())" : currency + "\(amount.removeZerosFromEnd())"
        self.type = isIncome ? "Income" : "Eexpense"
        self.account = account == "" ? nil : account
        self.category = category
        self.categoryColor = categoryColor
        self.categorySymbol = categorySymbol
        self.comment = comment
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        self.date = formatter.string(from: date)
        self.coordinates = coordinates
    }
}
