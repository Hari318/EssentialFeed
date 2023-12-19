//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Hari on 19/12/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
