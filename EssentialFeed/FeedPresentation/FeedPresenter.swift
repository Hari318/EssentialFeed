//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Hari on 08/12/23.
//

import Foundation

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
