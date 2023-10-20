//
//  TabView.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import SwiftUI

struct TabBarView: View {

    let homeView: HomeView
    let listView: ListView
    
    var body: some View {
            TabView {
                homeView
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                listView
                    .tabItem {
                        Label("List", systemImage: "list.bullet.rectangle.portrait")
                    }
                
            }.navigationBarTitleDisplayMode(.inline)
        }
}

struct TTabBarView_Previews: PreviewProvider {
    static var viewModel = NamesViewModel()
    
    static var previews: some View {
        TabBarView(homeView: HomeView(viewModel: viewModel),
                   listView: ListView(viewModel: viewModel,
                   pageView: PageView(viewModel: viewModel)))
    }
}
