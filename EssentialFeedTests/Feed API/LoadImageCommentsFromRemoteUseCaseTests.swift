//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 11/02/24.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL(){
        let url = URL(string: "https://url2.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestDataTwiceFromURL(){
        let url = URL(string: "https://url2.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{ _ in }
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        expect(sut, with: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon2xxHTTPErrorCode(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [199, 150, 300, 400, 500]
        
        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: failure(.invalidData)) {
                let json = makeJSON([])
                client.complete(withStatusCode: code, data: json,at: index)
            }
        }
    }
    
    func test_load_deliversErroron2xxHttpResponseWithInvalidJson(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [200, 201, 250, 280, 299]
        
        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: failure(.invalidData)) {
                let invalidJson = Data("invalid data".utf8)
                client.complete(withStatusCode: code, data: invalidJson, at: index)
            }
        }
    }
    
    func test_load_deliversNoItemOn2xxHttpResponseWithEmptyJsonList(){
        let (sut, client) = makeSUT()
        
        let errorCodes = [200, 201, 250, 280, 299]
        
        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: .success([]), when: {
                let emptyJsonData = makeJSON([])
                client.complete(withStatusCode: code, data: emptyJsonData, at: index)
            })
        }
    }
    
    func test_load_deliversFeedItemsOn2xxHttpResponseWithJsonList(){
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
        
        let errorCodes = [200, 201, 250, 280, 299]

        errorCodes.enumerated().forEach { index, code in
            expect(sut, with: .success(models), when: {
                let json = makeJSON([item1.json, item2.json])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversNoResultsAfterSutInstanceHasBeenDeallocated() {
        let url: URL = URL(string: "https://url1.com")!
        let client = HTTPClientSpy()
        var sut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)
        
        var capturedResults = [RemoteImageCommentsLoader.Result]()
        sut?.load { capturedResults.append($0)}
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (RemoteImageCommentsLoader, HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, client)
    }
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: RemoteImageCommentsLoader, with expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
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
