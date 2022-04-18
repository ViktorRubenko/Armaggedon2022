//
//  AsteroidDetailViewModelProtocol.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 17.04.2022.
//

import Foundation
import Combine

protocol AsteroidDetailViewModelProtocol: ViewModelProtocol {
    var asteroidInfo: CurrentValueSubject<AsteroidInfo?, Never> { get }
    var asteroidApproachData: CurrentValueSubject<[ApproachData], Never> { get }
    var errorPublisher: Published<String>.Publisher { get }
    
    func addToDestroyList()
}
