//
//  HomeView.swift
//  APIFuturesExample
//
//  Created by Paul on 19/10/2023.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: NamesViewModel
    
    public init(viewModel: NamesViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                ForEach(0..<10) { index in
                    VStack {
                        Text("Name: \(index)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                    }
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.vertical,8)
                }
            }
            .navigationTitle("Home View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: NamesViewModel())
    }
}
