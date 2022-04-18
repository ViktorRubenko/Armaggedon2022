//
//  FilterViewModelProtocol.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

protocol FilterViewModelProtocol {
    var units: CurrentValueSubject<Constants.Units, Never> { get }
    var onlyHazardous: CurrentValueSubject<Bool, Never> { get }
    var cells: [Constants.FilterCells] { get }
    func setHazardous(onlyHazardous: Bool)
    func setUnits(units: Constants.Units)
    func apply()
}
