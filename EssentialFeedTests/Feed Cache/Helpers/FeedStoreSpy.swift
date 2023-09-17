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
    }
    
    private(set) var receivedMessages = [ReceivedMessages]()
    
    private var deletionsCompletions = [DeletionCompletion]()
    private var insertionsCompletions = [InsertionCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionsCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionsCompletions[index](error)
    }
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionsCompletions[index](nil)
    }
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertionCompletion) {
        insertionsCompletions.append(completion)
        receivedMessages.append(.insert(feed, timeStamp))
    }
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionsCompletions[index](error)
    }
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionsCompletions[index](nil)
    }
}
