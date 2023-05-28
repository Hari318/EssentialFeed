//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 27/05/23.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase{
    
    func test_init_doesNotRequestDataFromURL(){
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL(){
        let url = URL(string: "https://url2.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_load_requestDataTwiceFromURL(){
        let url = URL(string: "https://url2.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "1", code: 0)
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0)}
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
}

// MARK: - Helpers

private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (RemoteFeedLoader, HTTPClientSpy){
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
}

private class HTTPClientSpy: HTTPClient{
    var requestURLs = [URL]()
    var error: Error?
    func get(from url: URL, completion: @escaping (Error) -> Void) {
        if let error = error{
            completion(error)
        }
        requestURLs.append(url)
    }
}

