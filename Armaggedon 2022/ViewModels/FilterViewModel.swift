//
//  FilterViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

enum FilterOptions {
    case all
    case units
}

final class FilterViewModel: FilterViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    private(set) var units: CurrentValueSubject<Constants.Units, Never>
    private(set) var onlyHazardous: CurrentValueSubject<Bool, Never>
    private(set) var cells: [Constants.FilterCells]

    init(options: FilterOptions = .all) {
        switch options {
        case .all:
            cells = [Constants.FilterCells.units, Constants.FilterCells.onlyHazardous]
        case .units:
            cells = [Constants.FilterCells.units]
        }
        units = CurrentValueSubject<Constants.Units, Never>(Constants.Units(rawValue: UserDefaults.standard.units)!)
        onlyHazardous = CurrentValueSubject<Bool, Never>(UserDefaults.standard.onlyHazardous)

        UserDefaults.standard.publisher(for: \.units)
            .sink { [weak self] rawValue in
                self?.units.send(Constants.Units(rawValue: rawValue)!)
            }.store(in: &cancellables)

        UserDefaults.standard.publisher(for: \.onlyHazardous)
            .sink { [weak self] value in
                self?.onlyHazardous.send(value)
            }.store(in: &cancellables)
    }

    func apply() {
        UserDefaults.standard.onlyHazardous = onlyHazardous.value
        UserDefaults.standard.units = units.value.rawValue
    }

    func setHazardous(onlyHazardous: Bool) {
        self.onlyHazardous.send(onlyHazardous)
    }

    func setUnits(units: Constants.Units) {
        self.units.send(units)
    }

}
