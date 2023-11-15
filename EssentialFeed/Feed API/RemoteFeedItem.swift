//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Hari on 10/09/23.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
