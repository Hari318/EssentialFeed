//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hari on 25/10/23.
//

import XCTest
@testable import EssentialFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversEmptyOnEmptyCache(_ sut: FeedStore) {
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(_ sut: FeedStore) {
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(_ sut: FeedStore) {
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        
        insert((feed, timeStamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timeStamp))
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(_ sut: FeedStore) {
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        
        insert((feed, timeStamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timeStamp))
    }
    
    func assertThatRetrieveDeliversFailureOnRetrievalError(_ sut: FeedStore) {
        expect(sut, toRetrieve: .failure(anyError()))
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(_ sut: FeedStore) {
        expect(sut, toRetrieveTwice: .failure(anyError()))
    }
    
}
