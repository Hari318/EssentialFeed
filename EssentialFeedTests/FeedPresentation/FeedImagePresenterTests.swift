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
        let view = ViewSpy()
        
        _ = FeedImagePresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    
    //MARK: - Helpers
    
    private class ViewSpy {
        var messages = [Any]()
        
    }
    
}
