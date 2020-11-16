//
//  HistoryView.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("History")
                Button(action: onClose) { Image(systemName: "xmark") }.padding()
            }
            List {
                ForEach(viewModel.history, id:\.self) { date in
                    Text("\(date)")
                }
            }
        }
    }
    
    func onClose() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
