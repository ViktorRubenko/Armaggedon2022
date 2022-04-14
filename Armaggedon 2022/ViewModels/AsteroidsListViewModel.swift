//
//  AsteroidsListViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

final class AsteroidsListViewModel: AsteroidListViewModelProtocol {
    private var responseAsteroids = [AsteroidModel]()
    private(set) var asteroids = CurrentValueSubject<[AsteroidCellModel], Never>([])
    @Published private(set) var error: String = ""
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
                    let asteroids = Mapper().asteroidsFromResponse(dataResponse.value!).sorted(by: { $0.approachDate < $1.approachDate })
                    self?.responseAsteroids = asteroids
                    self?.asteroids.send(asteroids.compactMap {
                        Mapper().asteroidModelToCellModel($0)
                    })
                }
            }.store(in: &cancellables)
    }
    
    private func createAlert(with error: NetworkError) {
        self.error = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.errorMessage
    }
}
