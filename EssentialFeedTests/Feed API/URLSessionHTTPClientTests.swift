//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 02/07/23.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    func get(from url: URL, completion: @escaping (HTTPClientResult)-> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTaskWithUrl() {
        let url = URL(string: "https://one.com")!
        
        let session = URLSessionSpy()
        let dataTask = URLSessionDataTaskSpy()
        session.stub(url: url, task: dataTask)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url, completion: { _ in })
        XCTAssertEqual(dataTask.resumeCount, 1)
    }
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://one.com")!
        let error = NSError(domain: "Any error", code: 1)
        let session = URLSessionSpy()
        let dataTask = URLSessionDataTaskSpy()
        session.stub(url: url, task: dataTask, error: error)
        
        let expectaion = expectation(description: "Wait for completion")
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error\(error) got \(result) instead")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 1.0)
    }
    private class URLSessionSpy: URLSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        func stub(url: URL, task: URLSessionDataTask, error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't fund stub for URL \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCount = 0
        override func resume() {
            resumeCount += 1
        }
    }
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
}
