//
//  TabView.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import SwiftUI

struct TabBarView: View {
    
    let viewModel: NamesViewModel
    let pageView: PageView
    
    var body: some View {
            TabView {
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ListView(viewModel: viewModel, pageView: pageView)
                    .tabItem {
                        Label("List", systemImage: "list.bullet.rectangle.portrait")
                    }
            }.navigationBarTitleDisplayMode(.inline)
        }
}

struct TTabBarView_Previews: PreviewProvider {
    static var viewModel = NamesViewModel()
    
    static var previews: some View {
        TabBarView(
            viewModel: viewModel,
            pageView: PageView(viewModel: viewModel))
    }
}
