//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Hari on 27/05/23.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
