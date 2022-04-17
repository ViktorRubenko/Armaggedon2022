//
//  AsteroidListViewModelProtocol.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

protocol AsteroidListViewModelProtocol: ViewModelProtocol {
    var asteroids: CurrentValueSubject<[AsteroidCellModel], Never> { get }
    var errorPublisher: Published<String>.Publisher { get }
    func addToDestroyList(_ id: String)
    func getResponseModel(_ id: String) -> AsteroidModel?
}
