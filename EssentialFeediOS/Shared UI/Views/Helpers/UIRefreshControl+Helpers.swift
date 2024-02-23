//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Hari on 23/02/24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
