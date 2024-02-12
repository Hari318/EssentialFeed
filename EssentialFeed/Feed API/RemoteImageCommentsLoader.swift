//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Hari on 11/02/24.
//

import Foundation

public final class RemoteImageCommentsLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    public typealias Result = FeedLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Result)-> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteImageCommentsLoader.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    private static func map(data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where  Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
    }
}
