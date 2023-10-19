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
           // HomeView(viewModel: viewModel)
          //  ListView(viewModel: viewModel, pageView: PageView(viewModel: viewModel))
        }
    }
}

class CompositionContainer {
        
    var viewModel: NamesViewModel
    
    init(viewModel: NamesViewModel) {
        self.viewModel = viewModel
        
    }
    
    public func makeContentView() -> ListView {
        let pageView = makePageView()

        return ListView(viewModel: viewModel, pageView: pageView)
    }
    
//    private func makeNamesViewModel() -> NamesViewModel {
//        return NamesViewModel(dataSource: dataSource)
//    }
    
    private func makePageView() -> PageView {
        return PageView(viewModel: viewModel)
    }
}
