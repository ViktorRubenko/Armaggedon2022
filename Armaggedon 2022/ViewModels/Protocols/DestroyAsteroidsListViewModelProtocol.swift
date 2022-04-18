//
//  DestroyAsteroidsListViewModelProtocol.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import Foundation
import Combine

protocol DestroyAsteroidsListViewModelProtocol: ViewModelProtocol {
    var asteroidsToDestroy: CurrentValueSubject<[AsteroidCellModel], Never> { get }
    func removeFromList(_ index: Int)
    func getResponseModel(_ index: Int) -> AsteroidModel
    func removeAll()
}
