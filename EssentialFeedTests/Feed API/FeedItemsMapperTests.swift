//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 27/05/23.
//

import XCTest
import EssentialFeed

class FeedItemsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([])
        
        let samples = [199, 201, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HttpResponseWithInvalidJson(){
        let invalidJson = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJson, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemOn200HttpResponseWithEmptyJsonList() throws {
        let emptyJsonData = makeJSON([])

        let result = try FeedItemsMapper.map(emptyJsonData, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversFeedItemsOn200HttpResponseWithJsonList() throws {
        let item1 = makeFeedItem(id: UUID(),
                             description: nil,
                             location: nil,
                             imageURL: URL(string: "http://url1.com")!)
        
        let item2 = makeFeedItem(id: UUID(),
                             description: "A description",
                             location: "A location",
                             imageURL: URL(string: "http://url2.com")!)
        
        let json = makeJSON([item1.json, item2.json])
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
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

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
