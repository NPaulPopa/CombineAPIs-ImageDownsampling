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
    
    init() {
        _viewModel = StateObject(wrappedValue: NamesViewModel())
    }

    var body: some Scene {
        
        WindowGroup {
            TabBarView(viewModel: viewModel,pageView: PageView(viewModel: viewModel))
        }
    }
}
