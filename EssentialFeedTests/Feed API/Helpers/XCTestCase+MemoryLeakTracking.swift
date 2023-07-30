//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Hari on 30/07/23.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocted. Potential memory leak.", file: file, line: line)
        }
    }
}
