//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Hari on 05/10/23.
//

import Foundation
@testable import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(),
                    description: "description",
                    location: "location",
                    url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let localItems = models.map { return LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (models, localItems)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -7)
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
