//
//  IndexPath+Extension.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/7/23.
//

import Foundation

extension IndexPath {
    public static func < (lhs: IndexPath, rhs: IndexPath) -> Bool {
        if lhs.section < rhs.section {
            return true
        } else if lhs.section > rhs.section {
            return false
        } else {
            return lhs.row < rhs.row
        }
    }
}
