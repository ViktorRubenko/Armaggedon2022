//
//  FilterViewModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import Combine

final class FilterViewModel: FilterViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    var units: CurrentValueSubject<Constants.Units, Never>
    var onlyHazardous: CurrentValueSubject<Bool, Never>
    
    init() {
        units = CurrentValueSubject<Constants.Units, Never>(Constants.Units(rawValue: UserDefaults.standard.units)!)
        onlyHazardous = CurrentValueSubject<Bool, Never>(UserDefaults.standard.onlyHazardous)
    }
    
    func apply(units: Constants.Units, onlyHazardous: Bool) {
        UserDefaults.standard.units = units.rawValue
        UserDefaults.standard.onlyHazardous = onlyHazardous
    }
    
    func fetch() {
        units.value = Constants.Units(rawValue: UserDefaults.standard.units)!
        onlyHazardous.value = UserDefaults.standard.onlyHazardous
    }
    
}
