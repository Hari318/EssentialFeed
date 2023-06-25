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
        
        expect(sut, with: .failure(RemoteFeedLoader.Error.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPErrorCode(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [199, 201, 300, 400, 500]
        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: .failure(RemoteFeedLoader.Error.invalidData)) {
                let json = makeJSON([])
                client.complete(withStatusCode: code, data: json,at: index)
            }
        }
    }
    
    func test_load_deliversErroron200HttpResponseWithInvalidJson(){
        let (sut, client) = makeSUT()

        expect(sut, with: .failure(RemoteFeedLoader.Error.invalidData)) {
            let data = Data("invalid data".utf8)
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_load_deliversNoItemOn200HttpResponseWithEmptyJsonList(){
        let (sut, client) = makeSUT()

        expect(sut, with: .success([]), when: {
            let emptyJsonData = makeJSON([])
            client.complete(withStatusCode: 200, data: emptyJsonData)
        })
    }
    
    func test_load_deliversFeedItemsOn200HttpResponseWithJsonList(){
        let (sut, client) = makeSUT()
        
        let item1 = makeFeedItem(id: UUID(),
                             description: nil,
                             location: nil,
                             imageURL: URL(string: "http://url1.com")!)
        
        
        let item2 = makeFeedItem(id: UUID(),
                             description: "A description",
                             location: "A location",
                             imageURL: URL(string: "http://url2.com")!)
        
        let models = [item1.model, item2.model]
        expect(sut, with: .success(models), when: {
            let json = makeJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_deliversNoResultsAfterSutInstanceHasBeenDeallocated() {
        let url: URL = URL(string: "https://url1.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load { capturedResults.append($0)}
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (RemoteFeedLoader, HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, client)
    }
    private func trackMemoryLeaks(instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocted. Potential memory leak.", file: file, line: line)
        }
    }
    private func expect(_ sut: RemoteFeedLoader, with expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but got \(receivedResult) instead.", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
    private func makeFeedItem(id: UUID,
                         description: String? = nil,
                         location: String? = nil,
                         imageURL: URL) -> (model: FeedItem, json: [String: Any]){
        let model = FeedItem(id: id,
                             description: description,
                             location: location,
                             imageURL: imageURL)
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues{$0}
        
        return (model, json)
    }
    private func makeJSON(_ items: [[String: Any]]) -> Data{
        let json = [
            "items": items
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
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
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0){
        let response = HTTPURLResponse(
            url: requestURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success(data, response))
    }
}
