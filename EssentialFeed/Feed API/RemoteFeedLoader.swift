//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Hari on 28/05/23.
//

import Foundation

public enum HTTPClientResult{
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient{
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader{
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    public enum Result: Equatable{
        case success([FeedItem])
        case failure(Error)
    }
    public init(url: URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Result)-> Void){
        client.get(from: url) { result in
            switch result{
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
