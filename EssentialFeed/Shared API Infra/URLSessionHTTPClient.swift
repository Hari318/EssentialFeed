//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Hari on 30/07/23.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnExpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapper: URLSessionTask
        
        func cancel() {
            wrapper.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result)-> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse{
                    return (data, response)
                }
                else {
                    throw UnExpectedValuesRepresentation()
                }
            })
            
        }
        task.resume()
        
        return URLSessionTaskWrapper(wrapper: task)
    }
}

//extension URLSession: HTTPClient {
//    private struct UnExpectedValuesRepresentation: Error {}
//
//    public func get(from url: URL, completion: @escaping (HTTPClientResult)-> Void) {
//        dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let data = data, let response = response as? HTTPURLResponse{
//                completion(.success(data, response))
//            }
//            else {
//                completion(.failure(UnExpectedValuesRepresentation()))
//            }
//        }.resume()
//    }
//}
