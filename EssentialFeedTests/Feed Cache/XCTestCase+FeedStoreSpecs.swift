//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hari on 24/10/23.
//

import XCTest
@testable import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    
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
    
    func assertThatSideEffectsRunSerially(on sut: FeedStore) {
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeed().local, timeStamp: Date(), completion: { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        })
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueImageFeed().local, timeStamp: Date(), completion: { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        })
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in wrong order")
    }
    
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timeStamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrieval")
        var insertionError: Error?
        
        sut.insert(cache.feed, timeStamp: cache.timeStamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return deletionError
    }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break
                
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(expected.feed, retrieved.feed)
                XCTAssertEqual(expected.timestamp, retrieved.timestamp)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult) but got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
