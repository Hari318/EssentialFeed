//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Hari on 21/02/24.
//

import Foundation

public final class ImageCommentsPresenter {
    public static var title: String {
        NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the comments view")
    }
}
