//
//  AsteroidModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation

struct AsteroidModel {
    let name: String
    let id: String
    let approachDate: Date
    let estimatedDiameter: Int
    let potentiallyHazardouds: Bool
    let missDistance: AsteroidDistance
}

struct AsteroidDistance {
    let kilometers: Int
    let lunar: Int
}
