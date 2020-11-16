//
//  ViewModel.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    static let url = "https://api.github.com"
    static let path = NSHomeDirectory() + "/Documents/response.json"
    static let delay: Double = 5.0
    @Published var response: GitHubResponse = GitHubResponse()
    @Published var history: [Date] = []
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        DispatchQueue.main.async {
            self.response = ViewModel.load(from: ViewModel.path) ?? GitHubResponse()
        }
    }
    
    func request() {
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: ViewModel.url)!)
            .map { $0.data }
            .decode(type: GitHubResponse.self, decoder: JSONDecoder())
            .replaceError(with: GitHubResponse())
            .receive(on: RunLoop.main)
            .handleEvents(receiveRequest:  { _ in
                self.history.append(Date())
            })
//            .print()
        Timer.publish(every: ViewModel.delay, on: .main, in: .default)
            .autoconnect()
            .delay(for: .seconds(ViewModel.delay), scheduler: RunLoop.main, options: .none)
            .flatMap { _ in publisher }
            .handleEvents(receiveOutput: { response in
                DispatchQueue.main.async {
                    ViewModel.save(response, to: ViewModel.path)
                }
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
