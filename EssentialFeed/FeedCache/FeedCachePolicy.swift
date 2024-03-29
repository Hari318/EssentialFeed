//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Hari on 07/10/23.
//

import Foundation

internal final class FeedCachePolicy {
    private init() {}
     
    private static let calendar = Calendar(identifier: .gregorian)

    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    internal static func validate(_ timeStamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timeStamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
