//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hari on 25/10/23.
//

import XCTest
@testable import EssentialFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversFailureOnRetrievalError(_ sut: FeedStore) {
        expect(sut, toRetrieve: .failure(anyError()))
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure(_ sut: FeedStore) {
        expect(sut, toRetrieveTwice: .failure(anyError()))
    }
    
}
