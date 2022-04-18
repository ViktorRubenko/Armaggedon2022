//
//  DestroyAsteroidsListViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import Foundation
import Combine

final class DestroyAsteroidsListViewModel: DestroyAsteroidsListViewModelProtocol {
    private(set) var asteroidsToDestroy = CurrentValueSubject<[AsteroidCellModel], Never>([])
    private var asteroids = [AsteroidModel]()
    private var databaseManager: DatabaseServiceProtocol
    private var mapper: MapperProtocol
    private var units: Constants.Units
    private var cancellables = Set<AnyCancellable>()

    init(databaseManager: DatabaseServiceProtocol = RealmManager.shared, mapper: MapperProtocol = Mapper()) {
        self.databaseManager = databaseManager
        self.mapper = mapper
        self.units = Constants.Units(rawValue: UserDefaults.standard.units)!

        databaseManager.changes.sink { [weak self] _ in
            self?.fetch()
        }.store(in: &cancellables)

        UserDefaults.standard
            .publisher(for: \.units)
            .sink { [weak self] rawValue in
                self?.units = Constants.Units(rawValue: rawValue)!
                self?.fetch()
            }.store(in: &cancellables)

        fetch()
    }

    func fetch() {
        asteroids = Array(databaseManager.get(
            fromEntity: AsteroidModel.self,
            sortedByKey: "approachDate",
            isAscending: true))
        asteroidsToDestroy.send(
            asteroids.compactMap { mapper.asteroidModelToCellModel($0, units: units, idsToDestroy: []) })
    }

    func removeFromList(_ index: Int) {
        databaseManager.delete(asteroids[index])
    }

    func getResponseModel(_ index: Int) -> AsteroidModel {
        asteroids[index]
    }

    func removeAll() {
        databaseManager.deleteAll(AsteroidModel.self)
    }
}
