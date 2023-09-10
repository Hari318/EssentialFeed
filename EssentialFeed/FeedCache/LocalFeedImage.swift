//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Hari on 10/09/23.
//

import Foundation

public struct LocalFeedImage: Equatable{
    let id: UUID
    let description: String?
    let location: String?
    let url: URL
}
