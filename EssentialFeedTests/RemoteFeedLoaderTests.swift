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
        sut.load{ _ in }
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_load_requestDataTwiceFromURL(){
        let url = URL(string: "https://url2.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{ _ in }
        sut.load{ _ in }
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0)}
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPErrorCode(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [199, 201, 300, 400, 500]
        errorCodes.enumerated().forEach { index, code in
            
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { capturedErrors.append($0)}
            
            client.complete(withStatusCode: code, at: index)
            
            XCTAssertEqual(capturedErrors, [.invalidData])
        }
    }
}

// MARK: - Helpers

private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (RemoteFeedLoader, HTTPClientSpy){
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
}

private class HTTPClientSpy: HTTPClient{
    private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()

    var requestURLs : [URL]{
        return messages.map{ $0.url }
    }
    
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0){
        messages[index].completion(error, nil)
    }
    
    func complete(withStatusCode code: Int, at index: Int = 0){
        let response = HTTPURLResponse(
            url: requestURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )
        messages[index].completion(nil, response)
    }
}

