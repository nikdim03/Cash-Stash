//
//  NSLayoutConstraintExtension.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/27/22.
//

import UIKit

extension NSLayoutConstraint {
  @discardableResult func activate() -> NSLayoutConstraint {
    isActive = true
    return self
  }
}
