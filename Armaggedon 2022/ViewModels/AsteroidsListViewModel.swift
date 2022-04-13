//
//  AsteroidsListViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

final class AsteroidsListViewModel: ObservableObject, AsteroidListViewModelProtocol {
    @Published private var asteroids = [AsteroidModel]()
    var asteroidsPublisher: Published<[AsteroidModel]>.Publisher { $asteroids }
    @Published private var error: String = ""
    var errorPublisher: Published<String>.Publisher { $error }
    
    private var cancellables = Set<AnyCancellable>()
    private var dataManager: ServiceProtocol
    
    init(dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        fetch()
    }
    
    func fetch() {
        dataManager.fetchAsteroids(startDate: "2022-01-01", endDate: nil)
            .sink { [weak self] dataResponse in
                if dataResponse.error != nil {
                    self?.createAlert(with: dataResponse.error!)
                } else {
                    self?.asteroids = Mapper().asteroidsFromResponse(dataResponse.value!)
                }
            }.store(in: &cancellables)
    }
    
    private func createAlert(with error: NetworkError) {
        self.error = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.errorMessage
    }
}
