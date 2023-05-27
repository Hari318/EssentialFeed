//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 27/05/23.
//

import XCTest

class RemoteFeedLoader{
    func load(){
        HTTPClient.shared.requestURL = URL(string: "https://url.com")
    }
}

class HTTPClient{
    static let shared = HTTPClient()
    
    private init(){}
    
    var requestURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase{
    
    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_load_requestDataFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestURL)
    }
}
