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
    
    @Published public var stateNames: [String] = []
    @Published public var showError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataSource = StateNamesDataSource()
        observeStateNames()
        print("Initialising ViewModel.....")
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
}
