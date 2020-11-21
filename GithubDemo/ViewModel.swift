//
//  ViewModel.swift
//  GithubDemo
//
//  Created by foolbear on 2020/11/17.
//

import SwiftUI
import Combine
import FoolUtilities

final class ViewModel: ObservableObject {
    static let url = "https://api.github.com"
    static let filename = "response.json"
    static let delay: Double = 5.0
    @Published var response: GitHubResponse = FoolFileHelper.read(from: filename) ?? GitHubResponse() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                FoolFileHelper.write(self.response, to: ViewModel.filename)
            }
        }
    }
    @Published var history: [Date] = []
    var subscriptions = Set<AnyCancellable>()
    
    func request() {
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: ViewModel.url)!)
            .map { $0.data }
            .decode(type: GitHubResponse.self, decoder: JSONDecoder())
            .replaceError(with: GitHubResponse())
            .receive(on: RunLoop.main)
            .handleEvents(receiveRequest:  { [weak self] _ in
                guard let self = self else { return }
                self.history.append(Date())
            })
//            .print()
        Timer.publish(every: ViewModel.delay, on: .main, in: .default)
            .autoconnect()
            .delay(for: .seconds(ViewModel.delay), scheduler: RunLoop.main, options: .none)
            .flatMap { _ in publisher }
            .assign(to: \.response, on: self)
            .store(in: &subscriptions)
    }
}
