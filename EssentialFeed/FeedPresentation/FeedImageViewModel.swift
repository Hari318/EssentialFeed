//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Hari on 10/12/23.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
