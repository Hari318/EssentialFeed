//
//  ListSnapShotTests.swift
//  EssentialFeediOSTests
//
//  Created by Hari on 23/02/24.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ListSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
    }
   
    
    // MARK: - Helpers
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyBoard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyBoard.instantiateInitialViewController() as! ListViewController
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        controller.loadViewIfNeeded()
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }
}
