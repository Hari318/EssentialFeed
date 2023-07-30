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
    
    struct UnExpectedValuesRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPClientResult)-> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnExpectedValuesRepresentation()))
            }
        }.resume()
    }
}
class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startIntercepting()
    }
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopIntercepting()
    }
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        makeSUT().get(from: url, completion: { _ in })

        wait(for: [exp], timeout: 1.0)
    }
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://one.com")!
        let error = NSError(domain: "Any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let expectaion = expectation(description: "Wait for completion")
        makeSUT().get(from: anyURL()) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertNotNil(receivedError)
            default:
                XCTFail("Expected failure with error\(error) got \(result) instead")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 1.0)
    }
    func test_getFromURL_failsOnAllNilValues() {
        URLProtocolStub.stub(data: nil, response: nil, error: nil)
        
        let expectaion = expectation(description: "Wait for completion")
        makeSUT().get(from: anyURL()) { result in
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected failure with error got \(result) instead")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 1.0)
    }
    
//  MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient{
        let sut = URLSessionHTTPClient()
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return sut
    }
    private func anyURL() -> URL{
        return URL(string: "https://one.com")!
    }
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest)-> Void)?
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        static func startIntercepting() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        static func stopIntercepting() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
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
