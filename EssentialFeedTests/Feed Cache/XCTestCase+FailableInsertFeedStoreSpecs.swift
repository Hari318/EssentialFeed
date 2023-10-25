//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hari on 25/10/23.
//

import XCTest
@testable import EssentialFeed

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    
    func assertThatInsertDeliversNoErrorsOnEmptyCache(_ sut: FeedStore) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func assertThatInsertDeliversNoErrorsOnNonEmptyCache(_ sut: FeedStore) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(_ sut: FeedStore) {
        let firstInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let latestFeed = uniqueImageFeed().local
        let latestTimeStamp = Date()
        let latestInsertionError = insert((latestFeed, latestTimeStamp), to: sut)
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
    }
    
    func assertThatInsertDeliversErrorOnInsertionError(_ sut: FeedStore) {
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        
        let insertionError = insert((feed, timeStamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(_ sut: FeedStore) {
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        
        insert((feed, timeStamp), to: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
}
