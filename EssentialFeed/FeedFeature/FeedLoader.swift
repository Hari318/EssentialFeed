//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Hari on 27/05/23.
//

import Foundation

enum LoadFeedResult{
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
