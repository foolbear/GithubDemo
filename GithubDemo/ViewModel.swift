//
//  ViewModel.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    let url = "https://api.github.com"
    let delay: Double = 5.0
    @Published var response: GitHubResponse = GitHubResponse()
    var subscriptions = Set<AnyCancellable>()
    
    func request() {
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map { $0.data }
            .decode(type: GitHubResponse.self, decoder: JSONDecoder())
            .replaceError(with: GitHubResponse())
            .receive(on: RunLoop.main)
            .print()
        Timer.publish(every: delay, on: .main, in: .default)
            .autoconnect()
            .delay(for: .seconds(delay), scheduler: RunLoop.main, options: .none)
            .flatMap { _ in publisher }
            .assign(to: \.response, on: self)
            .store(in: &subscriptions)
    }
}
