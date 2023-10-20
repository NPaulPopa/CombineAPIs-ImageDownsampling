//
//  StateNamesViewModel.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import SwiftUI
import Combine

class NamesViewModel: ObservableObject {
    
    public var dataSource: StateNamesDataSource
    public var imageFetcher: PhotoAPIManager
    
    @Published public var stateNames: [String] = []
    @Published public var showError: Bool = false
    @Published public var images: [UIImage] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataSource = StateNamesDataSource()
        imageFetcher = PhotoAPIManager()
        
        observeStateNames()
        fetchPhotos()
    }
    
    //MARK: - Methods
    
    func observeStateNames() {
        dataSource.requestData()
            .sink { completion in
                
                switch completion {
                case .failure(let error as StateNamesError):
                    self.showError = true
                    
                default: break
                }
                
            } receiveValue: { [weak self] states in
                
                guard let self = self else { return }
                
                self.stateNames = states
                
            }.store(in: &cancellables)
    }
    
    private func fetchPhotos() {
        let imageLinks = (0..<500).reduce([String]()) { result, _ in
            return result + ["https://picsum.photos/900"]
        }
        imageFetcher.fetchUIImages(from: imageLinks)
            .receive(on: DispatchQueue.main)
          //  .collect()
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.showError = true
                default: break
                }
            } receiveValue: { newImages in
             //   self.images.append(contentsOf: newImages)
                self.images.append(newImages)
            }
            .store(in: &cancellables)
    }
}
