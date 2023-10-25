//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hari on 25/10/23.
//

import XCTest
@testable import EssentialFeed

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    
    func  assertThatDeleteDeliversNoErrorsOnEmptyCache(_ sut: FeedStore) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(_ sut: FeedStore) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatDeleteDeliversNoErrorsOnNonEmptyCache(_ sut: FeedStore) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(_ sut: FeedStore) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatDeleteDeliversErrorOnDeletionError(_ sut: FeedStore) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(_ sut: FeedStore) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
}
