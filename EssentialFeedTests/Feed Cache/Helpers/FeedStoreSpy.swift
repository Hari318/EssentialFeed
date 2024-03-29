//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Hari on 17/09/23.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessages: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessages]()
    
    private var deletionsCompletions = [DeletionCompletion]()
    private var insertionsCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionsCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionsCompletions[index](.failure(error))
    }
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionsCompletions[index](.success(()))
    }
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        insertionsCompletions.append(completion)
        receivedMessages.append(.insert(feed, timeStamp))
    }
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionsCompletions[index](.failure(error))
    }
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionsCompletions[index](.success(()))
    }
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }
    func completeRetrieval(with feed: [LocalFeedImage], timeeStamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(CachedFeed(feed: feed, timestamp: timeeStamp)))
    }
}
