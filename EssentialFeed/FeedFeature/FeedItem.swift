//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Hari on 27/05/23.
//

import Foundation

public struct FeedItem: Equatable{
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}

extension FeedItem: Decodable{
    private enum CodingKeys: String, CodingKey{
        case id
        case description
        case location
        case imageURL = "image"
    }
}
