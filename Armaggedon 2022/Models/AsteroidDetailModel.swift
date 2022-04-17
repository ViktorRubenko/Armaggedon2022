//
//  AsteroidDetailCellModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 17.04.2022.
//

import Foundation

struct AsteroidInfo {
    let name: String
    let diameter: Int
    let hazardous: Bool
}

struct ApproachData {
    let dateString: String
    let velocity: String
    let distanceString: String
    let orbitingBody: String
}
