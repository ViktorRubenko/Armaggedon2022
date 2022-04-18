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
    private(set) var asteroidApproachData = CurrentValueSubject<[ApproachData], Never>([])
    private(set) var asteroidInfo = CurrentValueSubject<AsteroidInfo?, Never>(nil)
    
    private var asteroidModel: AsteroidModel
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkServiceProtocol
    private var databaseManager: DatabaseServiceProtocol
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
    
    init(asteroidModel: AsteroidModel, networkManager: NetworkServiceProtocol = NetworkManager.shared, databaseManager: DatabaseServiceProtocol = RealmManager.shared, mapper: MapperProtocol = Mapper()) {
        self.id = asteroidModel.id
        self.networkManager = networkManager
        self.databaseManager = databaseManager
        self.mapper = mapper
        self.units = .kilometers
        self.asteroidModel = asteroidModel
        
        asteroidInfo.send(mapper.asteroidModelToInfoModel(asteroidModel))
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
        guard let responseModel = responseModel else { return }
        asteroidApproachData.send(mapper.asteroidDetailCellFromResponse(responseModel, units: units))
    }
    
    private func createAlert(with error: NetworkError) {
        self.error = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.errorMessage
    }
    
    func addToDestroyList() {
        guard !databaseManager.exists(id: id, ofType: AsteroidModel.self) else { return }
        databaseManager.add(AsteroidModel(value: asteroidModel))
    }
}
