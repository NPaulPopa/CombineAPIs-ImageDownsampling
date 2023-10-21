//
//  PhotoAPIManager.swift
//  APIFuturesExample
//
//  Created by Paul on 20/10/2023.
//

import UIKit
import SwiftUI
import Combine

class PhotoAPIManager {
    
    private let urlString = "https://picsum.photos/900"
    private var cancellables = Set<AnyCancellable>()
    
    public func fetchUIImage() -> AnyPublisher<UIImage, Error> {
        
         guard let url = try? makeURL(from: urlString) else {
             return Fail(error: NetworkingError.badURL).eraseToAnyPublisher()
         }

        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { UIImage(data: $0.data) }
            .replaceNil(with: UIImage(systemName: "photo.fill")!)
            .eraseToAnyPublisher()
        
        print("Fetching image..")
        
        return publisher
    }
    
    public func fetchImage() -> AnyPublisher<Image, Error> {
        return fetchUIImage()
            .map { Image(uiImage: $0) }
            .eraseToAnyPublisher()
    }
    
    private func makeURL(from string: String) throws -> URL {
        guard let url = URL(string: string) else { throw NetworkingError.badURL }
        return url
    }
}

enum NetworkingError: Error {
    case badURL
}

extension PhotoAPIManager {
    
    public func fetchUIImages(from urls: [String]) -> AnyPublisher<UIImage, Never> {
        let urlPublishers = urls.compactMap { urlString -> AnyPublisher<Data, Error>? in
            guard let url = try? makeURL(from: urlString) else {
                return Fail(error: NetworkingError.badURL).eraseToAnyPublisher()
            }
            return URLSession.shared.dataTaskPublisher(for: url)
                .mapError { $0 as Error }
                .map { $0.data }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(urlPublishers)
            .compactMap { UIImage(data: $0) }
            .replaceError(with: UIImage(systemName: "photo.fill")!)
            .eraseToAnyPublisher()
    }
}
