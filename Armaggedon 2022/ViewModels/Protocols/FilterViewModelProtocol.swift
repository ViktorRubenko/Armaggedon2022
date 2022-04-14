//
//  FilterViewModelProtocol.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

protocol FilterViewModelProtocol: ViewModelProtocol {
    var units: CurrentValueSubject<Constants.Units, Never> { get }
    var onlyHazardous: CurrentValueSubject<Bool, Never> { get }
    func apply(units: Constants.Units, onlyHazardous: Bool)
}
