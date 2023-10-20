//
//  APIFuturesExampleApp.swift
//  APIFuturesExample
//
//  Created by Paul on 18/10/2023.
//

import SwiftUI

@main
struct APIFuturesExampleApp: App {
    
    @StateObject var viewModel: NamesViewModel
    
    let factory =  MainFactory()
    
    init() {
        _viewModel = StateObject(wrappedValue: NamesViewModel())
    }

    var body: some Scene {
        
        WindowGroup {
            TabBarView(homeView: factory.makeHomeView(viewModel: viewModel),
                       listView: factory.makeListView(viewModel: viewModel))
        }
    }
}
