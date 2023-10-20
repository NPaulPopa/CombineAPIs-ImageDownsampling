//
//  DependencyContainer.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import Foundation

class MainFactory {

    public func makeHomeView(viewModel: NamesViewModel) -> HomeView {
        HomeView(viewModel: viewModel)
    }
    
    public func makeListView(viewModel: NamesViewModel) -> ListView {
        let pageView = makePageView(viewModel: viewModel)
        return ListView(viewModel: viewModel, pageView: pageView)
    }
    
    public func makePageView(viewModel: NamesViewModel) -> PageView {
        PageView(viewModel: viewModel)
    }
}
