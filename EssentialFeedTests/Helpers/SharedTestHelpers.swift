//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Hari on 05/10/23.
//

import Foundation

func anyError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL{
    return URL(string: "https://one.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeJSON(_ items: [[String: Any]]) -> Data{
    let json = [
        "items": items
    ]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
