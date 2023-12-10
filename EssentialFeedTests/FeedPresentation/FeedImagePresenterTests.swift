//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 10/12/23.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        _ = FeedImagePresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    
    //MARK: - Helpers
    
    private class ViewSpy {
        var messages = [Any]()
        
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackMemoryLeaks(instance: view, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, view)
    }
    
}
