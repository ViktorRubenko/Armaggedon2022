//
//  FilterViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation

final class FilterViewModel: FilterViewModelProtocol {
    
    private(set) var units: Constants.Units
    private(set) var onlyHazardous: Bool
    private(set) var cells = [
        Constants.FilterCells.units,
        Constants.FilterCells.onlyHazardous
    ]
    
    init() {
        units = Constants.Units(rawValue: UserDefaults.standard.units)!
        onlyHazardous = UserDefaults.standard.onlyHazardous
    }
    
    func apply() {
        UserDefaults.standard.onlyHazardous = onlyHazardous
        UserDefaults.standard.units = units.rawValue
    }
    
    func setHazardous(onlyHazardous: Bool) {
        self.onlyHazardous = onlyHazardous
    }
    
    func setUnits(units: Constants.Units) {
        self.units = units
    }
    
}
