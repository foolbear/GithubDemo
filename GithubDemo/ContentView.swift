//
//  ContentView.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI

struct ContentView: View {
    @State private var sheetShowing = false
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("current_user_url")) {
                    Text("\(viewModel.response.current_user_url)")
                }
                Section(header: Text("current_user_authorizations_html_url")) {
                    Text("\(viewModel.response.current_user_authorizations_html_url)")
                }
                Section(header: Text("authorizations_url")) {
                    Text("\(viewModel.response.authorizations_url)")
                }
                Section(header: Text("...")) {
                    Text("...")
                }
            }
            .navigationBarTitle(Text("Github Demo"))
            .navigationBarItems(trailing: navigationBarTrailing)
            .sheet(isPresented: $sheetShowing) {
                self.sheetContent
            }
            .onAppear() {
                viewModel.request()
            }
        }
    }
}

extension ContentView {
    var navigationBarTrailing: some View {
        Button(action: onHistory) { Image(systemName: "clock") }.padding([.leading, .top, .bottom])
    }
    
    var sheetContent: some View {
        Text("I'm a history")
    }
    
    func onHistory() {
        sheetShowing = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
