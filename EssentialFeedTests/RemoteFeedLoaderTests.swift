//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 27/05/23.
//

import XCTest

class RemoteFeedLoader{
    func load(){
        HTTPClient.shared.get(from: URL(string: "https://url.com")!)
    }
}

class HTTPClient{
    static var shared = HTTPClient()
            
    func get(from url: URL){}
}

class HTTPClientSpy: HTTPClient{
    var requestURL: URL?
    
    override func get(from url: URL){
        requestURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase{
    
    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_load_requestDataFromURL(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestURL)
    }
}
