//
//  FeedLoaderPressentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Hari on 01/12/23.
//

import EssentialFeed
import EssentialFeediOS
import Combine

final class LoadResourcePressentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Swift.Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Swift.Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
            switch completion {
            case .finished: break
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        } receiveValue: { [weak self] resource in
            self?.presenter?.didFinishLoading(with: resource)
        }
    }
}

extension LoadResourcePressentationAdapter: FeedViewControllerDelegate {
    func didRequestFeedRefresh() {
        loadResource()
    }
}
