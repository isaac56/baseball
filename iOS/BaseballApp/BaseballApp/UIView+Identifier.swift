//
//  UIView+Identifier.swift
//  BaseballApp
//
//  Created by Song on 2021/05/09.
//

import UIKit

extension UIView {
    static var identifier: String {
        return "\(self)"
    }
}

extension UIView {
    static func loadFromNib<T>() -> T? {
        let identifier = String(describing: T.self)
        let view = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first
        return view as? T
    }
}
