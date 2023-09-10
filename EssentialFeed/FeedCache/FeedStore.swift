//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Hari on 10/09/23.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], timeStamp: Date, completion: @escaping InsertionCompletion)
}

public struct LocalFeedItem: Equatable{
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
