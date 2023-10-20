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
                ForEach(viewModel.images, id: \.self) { image in
                    LazyVStack {
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()

                        Text("Hello from image")
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                        }
                    }
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.vertical,8)
                }
            }
            
            .navigationTitle("Home View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(Color.primary)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: NamesViewModel())
    }
}
