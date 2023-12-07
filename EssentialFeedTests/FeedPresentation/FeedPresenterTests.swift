//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 07/12/23.
//

import XCTest

final class FeedPresenter {
    init (view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    
    private class ViewSpy {
        var messages = [Any]()
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackMemoryLeaks(instance: view, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, view)
    }
}
