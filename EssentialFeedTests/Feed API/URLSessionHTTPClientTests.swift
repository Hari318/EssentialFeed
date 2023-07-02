//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 02/07/23.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}
class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_createsDataTaskFromUrl() {
        let url = URL(string: "https://one.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receiverUrls, [url])
    }
    
    private class URLSessionSpy: URLSession {
        var receiverUrls = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receiverUrls.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
