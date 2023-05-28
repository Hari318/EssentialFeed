//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 27/05/23.
//

import XCTest

class RemoteFeedLoader{
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    func load(){
        client.get(from: url)
    }
}

protocol HTTPClient{
    func get(from url: URL)
}

class RemoteFeedLoaderTests: XCTestCase{
    
    func test_init_doesNotRequestDataFromURL(){
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestURL)
    }
    
    func test_load_requestDataFromURL(){
        let url = URL(string: "https://url2.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        XCTAssertNotNil(client.requestURL)
    }
}

// MARK: - Helpers

private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (RemoteFeedLoader, HTTPClientSpy){
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    return (sut, client)
}

private class HTTPClientSpy: HTTPClient{
    var requestURL: URL?
    
    func get(from url: URL){
        requestURL = url
    }
}

