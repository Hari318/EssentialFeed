//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Hari on 16/01/24.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class FeedSnapshotTests: XCTestCase {

    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_CONTENT_dark")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()
        
        sut.display(feedWithFailedImageLoading())
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_dark")
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
    
    private func feedWithContent() -> [ImageStub] {
        return [
            ImageStub(
                description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Garth Pier",
                image: UIImage.make(withColor: .green)
            )
        ]
    }
    
    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [
            ImageStub(
                description: nil,
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: nil
            ),
            ImageStub(
                description: nil,
                location: "Garth Pier",
                image: nil
            )
        ]
    }
}

private extension ListViewController {
    func display(_ stubs: [ImageStub]) {
//        let cells: [CellController] = stubs.map { stub in
//            let controller = CellController(viewModel: stub.viewModel, delegate: stub)
//            stub.controller = controller
//            return CellController(dataSource: controller)
//        }
        let cells: [CellController] = stubs.map { stub in
                    let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub)
                    stub.controller = cellController
                    return CellController(cellController)
                }
        
        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel
    let image: UIImage?
    weak var controller: FeedImageCellController?
    
    init(description: String?, location: String?, image: UIImage?) {
        self.viewModel = FeedImageViewModel(
            description: description,
            location: location)
        self.image = image
    }
    
    func didRequestImage() {
        controller?.display(ResourceLoadingViewModel(isLoading: false))
        if let image = image {
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(message: .none))
        } else {
            controller?.display(ResourceErrorViewModel(message: "any"))
        }
    }
    
    func didCancelImageRequest() {}
}