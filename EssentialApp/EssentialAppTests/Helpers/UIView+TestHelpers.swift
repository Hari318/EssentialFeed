//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Hari on 19/01/24.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
