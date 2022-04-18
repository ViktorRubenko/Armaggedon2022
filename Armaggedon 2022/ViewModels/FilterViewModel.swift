//
//  FilterViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation

enum FilterOptions {
    case all
    case units
}

final class FilterViewModel: FilterViewModelProtocol {

    private(set) var units: Constants.Units
    private(set) var onlyHazardous: Bool
    private(set) var cells: [Constants.FilterCells]

    init(options: FilterOptions = .all) {
        switch options {
        case .all:
            cells = [Constants.FilterCells.units, Constants.FilterCells.onlyHazardous]
        case .units:
            cells = [Constants.FilterCells.units]
        }
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
