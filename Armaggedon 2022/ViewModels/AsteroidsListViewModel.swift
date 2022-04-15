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
    private var onlyHazardous: Bool {
        didSet {
            if onlyHazardous != oldValue {
                update()
            }
        }
    }
    private var units: Constants.Units {
        didSet {
            if units != oldValue {
                update()
            }
        }
    }
    
    init(dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        self.onlyHazardous = UserDefaults.standard.onlyHazardous
        self.units = Constants.Units(rawValue: UserDefaults.standard.units)!

        UserDefaults.standard
            .publisher(for: \.units)
            .sink { [weak self] rawValue in
                self?.units = Constants.Units(rawValue: rawValue)!
            }.store(in: &cancellables)
        
        UserDefaults.standard
            .publisher(for: \.onlyHazardous)
            .sink { [weak self] value in
                self?.onlyHazardous = value
            }.store(in: &cancellables)
        
        fetch()
    }
    
    func fetch() {
        dataManager.fetchAsteroids(startDate: "2022-01-01", endDate: nil)
            .sink { [weak self] dataResponse in
                guard self != nil else { return }
                if dataResponse.error != nil {
                    self!.createAlert(with: dataResponse.error!)
                } else {
                    self!.responseAsteroids = Mapper().asteroidsFromResponse(dataResponse.value!).sorted(by: { $0.approachDate < $1.approachDate })
                    self!.update()
                }
            }.store(in: &cancellables)
    }
    
    private func createAlert(with error: NetworkError) {
        self.error = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.errorMessage
    }
    
    private func update() {
        if onlyHazardous {
            asteroids.send(responseAsteroids.filter({ $0.potentiallyHazardouds }).compactMap {
                Mapper().asteroidModelToCellModel($0, units: units)
            })
        } else {
            asteroids.send(responseAsteroids.compactMap {
                Mapper().asteroidModelToCellModel($0, units: units)
            })
        }
    }
}
