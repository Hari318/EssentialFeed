//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Hari on 10/09/23.
//

import Foundation

public struct LocalFeedItem: Equatable{
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
