//
//  Constants.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import UIKit

enum Constants {
    enum GradientColors {
        static let green: [CGColor] = [
            UIColor(red: 203/255, green: 243/255, blue: 125/255, alpha: 1).cgColor,
            UIColor(red: 125/255, green: 232/255, blue: 140/255, alpha: 1).cgColor
        ]
        static let red: [CGColor] = [
            UIColor(red: 255/255, green: 177/255, blue: 153/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 8/255, blue: 68/255, alpha: 1).cgColor
        ]
        static let lightGreen: [CGColor] = [
            UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1).cgColor,
            UIColor(red: 105/255, green: 202/255, blue: 120/255, alpha: 1).cgColor
        ]
        static let lightRed: [CGColor] = [
            UIColor(red: 255/255, green: 205/255, blue: 204/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 8/255, blue: 68/255, alpha: 1).cgColor
        ]
    }
    enum Colors {
        static let primaryLabelColor: UIColor = .black
        static let destroyButtonColor: UIColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        static let secondaryLabelColor: UIColor = .white
    }
    enum Units: String, CaseIterable {
        case kilometers = "км"
        case lunar = "л.орб."
    }
    enum FilterCells {
        case units
        case onlyHazardous
    }
    static let planets  = [
        "Mercury": "Меркурий",
        "Venus": "Венера",
        "Earth": "Земля",
        "Mars": "Марс",
        "Jupiter": "Юпитер",
        "Saturn": "Сатунр",
        "Uranus": "Уран",
        "Neptune": "Нептун"
    ]
}
