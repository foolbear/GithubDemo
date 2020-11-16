//
//  ContentView.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("current_user_url")) {
                Text("test response")
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
