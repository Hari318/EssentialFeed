//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Hari on 27/05/23.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
