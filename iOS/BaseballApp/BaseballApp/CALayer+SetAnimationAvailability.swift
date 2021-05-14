//
//  CALayer+SetAnimationAvailability.swift
//  BaseballApp
//
//  Created by Song on 2021/05/14.
//

import UIKit

extension CALayer {
    var areAnimationsEnabled: Bool {
        get { delegate == nil }
        set { delegate = newValue ? nil : CALayerAnimationsDisablingDelegate.shared }
    }
}

private class CALayerAnimationsDisablingDelegate: NSObject, CALayerDelegate {
    static let shared = CALayerAnimationsDisablingDelegate()
    private let null = NSNull()

    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        null
    }
}
