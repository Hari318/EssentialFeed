//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 02/07/23.
//

import XCTest
import EssentialFeed

//protocol HTTPSession {
//    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
//}
//protocol HTTPSessionTask {
//    func resume()
//}
class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    func get(from url: URL, completion: @escaping (HTTPClientResult)-> Void) {
//        let url = URL(string: "https://wrong-url.com")!
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://one.com")!
        let error = NSError(domain: "Any error", code: 1)
        URLProtocolStub.startIntercepting()
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let expectaion = expectation(description: "Wait for completion")
        let sut = URLSessionHTTPClient()
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertNotNil(receivedError)
            default:
                XCTFail("Expected failure with error\(error) got \(result) instead")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 1.0)
        URLProtocolStub.stopIntercepting()
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        static func startIntercepting() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        static func stopIntercepting() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        override func startLoading() {
//            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        override func stopLoading() {}
    }
}
