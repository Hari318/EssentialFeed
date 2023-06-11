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
        
        expect(sut, with: .connectivity) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPErrorCode(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [199, 201, 300, 400, 500]
        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: .invalidData) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErroron200HttpResponseWithInvalidJson(){
        let (sut, client) = makeSUT()

        expect(sut, with: .invalidData) {
            let data = Data("invalid data".utf8)
            client.complete(withStatusCode: 200, data: data)
        }
    }
}

// MARK: - Helpers
private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (RemoteFeedLoader, HTTPClientSpy){
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
}
private func expect(_ sut: RemoteFeedLoader, with error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
    var capturedErrors = [RemoteFeedLoader.Error]()
    sut.load { capturedErrors.append($0)}
    
    action()
    
    XCTAssertEqual(capturedErrors, [error], file: file, line: line)
}
// MARK: - Spy
private class HTTPClientSpy: HTTPClient{
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

    var requestURLs : [URL]{
        return messages.map{ $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0){
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0){
        let response = HTTPURLResponse(
            url: requestURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success(data, response))
    }
}

