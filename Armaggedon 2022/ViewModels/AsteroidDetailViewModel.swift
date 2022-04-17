//
//  AsteroidDetailViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 17.04.2022.
//

import Foundation
import Combine

final class AsteroidDetailViewModel: AsteroidDetailViewModelProtocol {
    @Published private(set) var error: String = ""
    var errorPublisher: Published<String>.Publisher { $error }
    private(set) var asteroid = CurrentValueSubject<AsteroidDetailModel?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkServiceProtocol
    private var mapper: MapperProtocol
    private var id: String
    private var responseModel: NearEarthObject!
    private var units: Constants.Units {
        didSet {
            if units != oldValue {
                update()
            }
        }
    }
    
    init(id: String, networkManager: NetworkServiceProtocol = NetworkManager.shared, mapper: MapperProtocol = Mapper()) {
        self.id = id
        self.networkManager = networkManager
        self.mapper = mapper
        self.units = .kilometers
        
        UserDefaults.standard
            .publisher(for: \.units)
            .sink { [weak self] rawValue in
                self?.units = Constants.Units(rawValue: rawValue)!
            }.store(in: &cancellables)
        
        self.fetch()
    }
    
    func fetch() {
        networkManager.fetchAsteroid(id: self.id)
            .sink { [weak self] dataResponse in
                guard self != nil else { return }
                if dataResponse.error != nil {
                    self!.createAlert(with: dataResponse.error!)
                } else {
                    self!.responseModel = dataResponse.value!
                    self!.update()
                }
            }.store(in: &cancellables)
    }
    
    private func update() {
        asteroid.send(mapper.asteroidDetailCellFromResponse(responseModel, units: units))
    }
    
    private func createAlert(with error: NetworkError) {
        self.error = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.errorMessage
    }
}
