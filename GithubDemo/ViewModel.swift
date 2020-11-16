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
    
    init() {
        self.response = ViewModel.load(from: NSHomeDirectory() + "/Documents/response.json") ?? GitHubResponse()
    }
    
    func request() {
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map { $0.data }
            .decode(type: GitHubResponse.self, decoder: JSONDecoder())
            .replaceError(with: GitHubResponse())
            .receive(on: RunLoop.main)
//            .print()
        Timer.publish(every: delay, on: .main, in: .default)
            .autoconnect()
            .delay(for: .seconds(delay), scheduler: RunLoop.main, options: .none)
            .flatMap { _ in publisher }
            .handleEvents(receiveOutput: { response in
                ViewModel.save(response, to: NSHomeDirectory() + "/Documents/response.json")
            })
            .assign(to: \.response, on: self)
            .store(in: &subscriptions)
    }
    
    static func load(from path: String) -> GitHubResponse? {
        let url = URL(fileURLWithPath: path)
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: url), let response = try? decoder.decode(GitHubResponse.self, from: data) else {
            return nil
        }
        return response
    }
    
    static func save(_ response: GitHubResponse, to path: String) {
        let url = URL(fileURLWithPath: path)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(response) {
            try? data.write(to: url)
        }
    }
}
