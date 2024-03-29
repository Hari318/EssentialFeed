//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Hari on 29/11/23.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeysAndValueExists(in: bundle, table)
    }
}
