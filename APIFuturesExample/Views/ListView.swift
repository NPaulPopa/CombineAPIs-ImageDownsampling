//
//  ContentView.swift
//  APIFuturesExample
//
//  Created by Paul on 18/10/2023.
//

import SwiftUI
import Combine

struct ListView: View {
    
    @ObservedObject private var viewModel: NamesViewModel
    private let pageView: PageView

    public init(viewModel: NamesViewModel,
                pageView: PageView) {
        
        self.viewModel = viewModel
        self.pageView = pageView
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                NavigationLink("Navigate to PageDetail") {
                    pageView
                }.padding()
                
                Text("List of States")
                    .padding()
                
                Divider()
                
                List {
                    ForEach(viewModel.stateNames,id: \.self) { name in
                        Text(name)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.stateNames = []
                        viewModel.observeStateNames()
                    }
                } label: {
                    Text("Fetch Data")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(55)
                        .padding()
                }
 
            }.navigationTitle("List View")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showError) {
                       Alert(
                           title: Text("Error"),
                           message: Text("An error occurred."),
                           dismissButton: .default(Text("OK")) {
                               self.viewModel.observeStateNames()
                           }
                       )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var viewModel = NamesViewModel()
        
    static var previews: some View {
        ListView(
            viewModel: viewModel,
            pageView: PageView(viewModel: viewModel))
    }
}

extension NamesViewModel {
    
    convenience init(dataSource: StateNamesDataSource) {
        self.init()
        self.dataSource = dataSource
    }
}
