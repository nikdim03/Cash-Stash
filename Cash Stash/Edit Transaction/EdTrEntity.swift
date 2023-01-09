//
//  EdTrEntity.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import Foundation

class InitData {
    let segInd: Int
    let title: String
    let amount: String
    let comment: String?
    let category: String
    let date: Date
    
    init(segInd: Int, title: String, amount: String, comment: String?, category: String, date: String) {
        self.segInd = segInd
        self.title = title
        self.amount = String(amount.dropFirst())
        self.comment = comment
        self.category = category
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        self.date = dateFormatter.date(from: date) ?? Date()
    }
}
