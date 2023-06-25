//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Hari on 28/05/23.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Result)-> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let root = try FeedItemsMapper.map(data: data, response: response)
            return .success(root)
        } catch {
            return .failure(.invalidData)
        }
    }
}
