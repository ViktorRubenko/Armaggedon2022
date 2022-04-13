//
//  AsteroidListViewModelProtocol.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

protocol AsteroidListViewModelProtocol: ViewModelProtocol {
    var asteroidsPublisher: Published<[AsteroidModel]>.Publisher { get }
    var errorPublisher: Published<String>.Publisher { get }
}
