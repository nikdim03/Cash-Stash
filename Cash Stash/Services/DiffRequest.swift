//
//  DiffRequest.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import Foundation

struct DiffRequest: Codable {
    let currentClientTimestamp: Int
    let serverTimestamp: Int
}
