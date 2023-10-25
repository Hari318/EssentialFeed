//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Hari on 25/10/23.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {
    public init() {}

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}
