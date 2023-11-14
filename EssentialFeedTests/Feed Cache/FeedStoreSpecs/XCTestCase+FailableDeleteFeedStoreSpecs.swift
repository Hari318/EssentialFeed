//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hari on 25/10/23.
//

import XCTest
@testable import EssentialFeed

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    
    func assertThatDeleteDeliversErrorOnDeletionError(_ sut: FeedStore) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .success(.empty))
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError(_ sut: FeedStore) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.empty))
    }
    
}
