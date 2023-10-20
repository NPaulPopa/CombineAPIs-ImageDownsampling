//
//  PageView.swift
//  APIFuturesExample
//
//  Created by Paul on 18/10/2023.
//

import SwiftUI

struct PageView: View {
    @ObservedObject private var viewModel: NamesViewModel

    public init(viewModel: NamesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
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
 
            }.navigationTitle("Page View")
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

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(
            viewModel: NamesViewModel()
        )
    }
}
