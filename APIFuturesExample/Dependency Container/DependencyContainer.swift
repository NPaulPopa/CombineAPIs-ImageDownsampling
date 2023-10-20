//
//  DependencyContainer.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import Foundation

class DependencyContainer {
        
    var viewModel: NamesViewModel
    
    init(viewModel: NamesViewModel) {
        self.viewModel = viewModel
        
    }
    
    public func makeContentView() -> ListView {
        let pageView = makePageView()

        return ListView(viewModel: viewModel, pageView: pageView)
    }
    
    private func makePageView() -> PageView {
        return PageView(viewModel: viewModel)
    }
}
