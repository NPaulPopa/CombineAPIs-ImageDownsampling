//
//  StateNames.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import Foundation
import Combine

class StateNamesDataSource {
    
    //MARK: Properties

    private var stateNamesFuture: Future<[String],Error>?
    private let stateNamesData = StateNamesData()
    
    init() { }
    
    //MARK: Public methods
    
    public func requestData() -> Future<[String],Error> {
            
            if let storedFuture = stateNamesFuture {
                return storedFuture
            } else {
                let newFuture = makeStateNamesFuture()
                return newFuture
            }
        }
    
    public func retryRequest() {
        self.stateNamesFuture = makeStateNamesFuture()
    }
    
    //MARK: Private methods
    
    private func makeStateNamesFuture() -> Future<[String],Error> {
        let future = Future<[String],Error> { [weak self] promise in
            
            guard let self = self else { return }
            
            self.getNamesAfter(delay: 1.5) { names, error in
                if let error = error {
                    promise(.failure(error))
                } else if let names = names {
                    promise(.success(names))
                }
            }
        }
        
        return future
    }
    
    private func getNamesAfter(delay: TimeInterval, completion: @escaping ([String]?, Error?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
            
            guard let self = self else { return }
            
            let data = self.makeNamesArray()
            let shouldReturnError = false //Bool.random()
            
            let returnResult = shouldReturnError ? "ERROR" : "SUCCESS"
            
            print("\n Requesting Data...\n","Returned: \(returnResult) \n")

            if shouldReturnError {
                DispatchQueue.main.async {
                    completion(nil, StateNamesError.invalidData)
                }
            } else {
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }
    }
    
    
    //MARK: - Helpers
    
    @discardableResult
    private func makeNamesArray() -> [String] {
        let names = stateNamesData.names
        
        let states = names.components(separatedBy: "\n")
            .reduce(into: [String]()) { result, state in
                let components = state.components(separatedBy: "|")
                if components.count == 2 {
                    result.append(components[1])
                }
            }
                
        return states
    }
}

public enum StateNamesError: Error {
    
    case invalidData
}
