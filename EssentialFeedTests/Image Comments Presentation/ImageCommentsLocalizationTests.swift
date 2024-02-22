//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Hari on 21/02/24.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeysAndValueExists(in: bundle, table)
    }
    
}
