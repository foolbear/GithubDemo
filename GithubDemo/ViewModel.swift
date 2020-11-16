//
//  ViewModel.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    @Published var response: GitHubResponse = GitHubResponse()
    var subscriptions = Set<AnyCancellable>()
    
    func request() {
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.github.com")!)
            .map { $0.data }
            .decode(type: GitHubResponse.self, decoder: JSONDecoder())
            .replaceError(with: GitHubResponse())
            .receive(on: RunLoop.main)
            .print()
        Timer.publish(every: 5.0, on: .main, in: .default)
            .autoconnect()
            .delay(for: .seconds(5.0), scheduler: RunLoop.main, options: .none)
            .flatMap { _ in publisher }
            .assign(to: \.response, on: self)
            .store(in: &subscriptions)
    }
}
