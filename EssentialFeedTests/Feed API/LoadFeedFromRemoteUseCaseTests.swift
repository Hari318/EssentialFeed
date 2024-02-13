//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 27/05/23.
//

import XCTest
@testable import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
    
    
    func test_load_deliversErrorOnNon200HTTPErrorCode(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [199, 201, 300, 400, 500]
        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: failure(.invalidData)) {
                let json = makeJSON([])
                client.complete(withStatusCode: code, data: json,at: index)
            }
        }
    }
    
    func test_load_deliversErroron200HttpResponseWithInvalidJson(){
        let (sut, client) = makeSUT()

        expect(sut, with: failure(.invalidData)) {
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
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (RemoteFeedLoader, HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, client)
    }
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
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
                         imageURL: URL) -> (model: FeedImage, json: [String: Any]){
        let model = FeedImage(id: id,
                             description: description,
                             location: location,
                             url: imageURL)
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
