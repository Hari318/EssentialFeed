//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Hari on 24/02/24.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(comments())
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "IMAGE_COMMENTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "IMAGE_COMMENTS_dark")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyBoard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyBoard.instantiateInitialViewController() as! ListViewController
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        controller.loadViewIfNeeded()
        return controller
    }
    
    private func comments() -> [CellController] {
        commentsControllers().map { CellController(dataSource: $0) }
    }
    
    private func commentsControllers() -> [ImageCommentCellController] {
        return [
            ImageCommentCellController(viewModel: ImageCommentViewModel(message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.", date: "100 years ago", username: "a long long long username")),
            ImageCommentCellController(viewModel: ImageCommentViewModel(message: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.", date: "1 day ago", username: "a username")),
            ImageCommentCellController(viewModel: ImageCommentViewModel(message: "Garth Pier", date: "1 hour ago", username: "a."))
        ]
    }
}
