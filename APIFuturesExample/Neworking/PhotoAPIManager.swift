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
    
    public func getSingleDownsampledImagePublisher(urlString: String) -> AnyPublisher<UIImage,Error> {
        guard let url = try? makeURL(from: urlString) else {
            return Fail(error: NetworkingError.badURL).eraseToAnyPublisher()
        }
        
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .compactMap {
                let imageSource = CGImageSourceCreateWithData($0.data as CFData, imageSourceOptions)
                return self.downsample(imageSource: imageSource!)
            }
            .eraseToAnyPublisher()
    }
    
    public func getDownsampledImagesPublisher(urlStrings: [String]) -> AnyPublisher<UIImage,Never> {
        
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        let urlPublishers = urlStrings.compactMap { urlString -> AnyPublisher<CGImageSource, Error>? in
            guard let url = try? makeURL(from: urlString) else {
                return Fail(error: NetworkingError.badURL).eraseToAnyPublisher()
            }
            return URLSession.shared.dataTaskPublisher(for: url)
            
                .mapError { $0 as Error }
                .compactMap { CGImageSourceCreateWithData($0.data as CFData, imageSourceOptions) }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(urlPublishers)
            .receive(on: DispatchQueue.global(), options: nil)
            .compactMap { self.downsample(imageSource: $0) }
            .replaceError(with: UIImage(systemName: "photo.fill")!)
            .eraseToAnyPublisher()
    }
    
    func downsampledImagesArrayPublisher(urlPublishers: [AnyPublisher<CGImageSource, Error>]) async -> AnyPublisher<UIImage, Never> {
        return try! await withThrowingTaskGroup(of: AnyPublisher<UIImage, Never>.self) { group in
            
            var imagePublisher: [AnyPublisher<UIImage, Never>] = []
            
            for publisher in urlPublishers {
                group.addTask {
                    print("We're inside the for loop ....")
                    return publisher
                        .mapError { $0 as Error }
                        .compactMap { self.downsample(imageSource: $0) }
                        .replaceError(with: UIImage(systemName: "photo.fill")!)
                        .eraseToAnyPublisher()
                }
            }
            
            for try await image in group {
                imagePublisher.append(image.eraseToAnyPublisher())
            }
            
            return Publishers.MergeMany(imagePublisher)
                .receive(on: DispatchQueue.global(), options: nil)
                .replaceError(with: UIImage(systemName: "photo.fill")!)
                .eraseToAnyPublisher()
        }
    }
    
    //MARK: - Image downsampling
    
    private func downsample(imageSource: CGImageSource, to pointSize: CGSize = CGSize(width: 400, height: 400), scale: CGFloat = 3.0) -> UIImage {
     
     let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
     let downsampleOptions =
     [kCGImageSourceCreateThumbnailFromImageAlways: true,
     kCGImageSourceShouldCacheImmediately: true,
     kCGImageSourceCreateThumbnailWithTransform: true,
     kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
     
     let downsampledImage =
     CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
     return UIImage(cgImage: downsampledImage)
    }
}
