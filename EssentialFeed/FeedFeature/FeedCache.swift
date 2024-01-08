//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Hari on 06/01/24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
