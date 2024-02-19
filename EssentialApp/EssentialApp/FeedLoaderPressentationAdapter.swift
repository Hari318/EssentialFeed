//
//  FeedLoaderPressentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Hari on 01/12/23.
//

import EssentialFeed
import EssentialFeediOS
import Combine

final class FeedLoaderPressentationAdapter: FeedViewControllerDelegate {    
    private let feedLoader: () -> AnyPublisher<[FeedImage], Swift.Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?
    
    init(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Swift.Error>) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        cancellable = feedLoader()
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
            switch completion {
            case .finished: break
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        } receiveValue: { [weak self] feed in
            self?.presenter?.didFinishLoading(with: feed)
        }
    }
}
