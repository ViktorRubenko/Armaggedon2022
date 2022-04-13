//
//  ResponseModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 13.04.2022.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let links: ResponseLinks
    let nearEarthObjects: [String: [NearEarthObject]]

    enum CodingKeys: String, CodingKey {
        case links
        case nearEarthObjects = "near_earth_objects"
    }
}

// MARK: - ResponseLinks
struct ResponseLinks: Codable {
    let next, prev: String
}

// MARK: - NearEarthObject
struct NearEarthObject: Codable {
    let id, neoReferenceID, name: String
    let estimatedDiameter: EstimatedDiameter
    let isPotentiallyHazardousAsteroid: Bool
    let closeApproachData: [CloseApproachDatum]

    enum CodingKeys: String, CodingKey {
        case id
        case neoReferenceID = "neo_reference_id"
        case name
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case closeApproachData = "close_approach_data"
    }
}

// MARK: - CloseApproachDatum
struct CloseApproachDatum: Codable {
    let epochDateCloseApproach: Int
    let missDistance: MissDistance

    enum CodingKeys: String, CodingKey {
        case epochDateCloseApproach = "epoch_date_close_approach"
        case missDistance = "miss_distance"
    }
}

// MARK: - MissDistance
struct MissDistance: Codable {
    let lunar, kilometers: String
}

// MARK: - EstimatedDiameter
struct EstimatedDiameter: Codable {
    let meters: DiamaterUnits
}

// MARK: - DiamaterUnits
struct DiamaterUnits: Codable {
    let estimatedDiameterMin, estimatedDiameterMax: Double

    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}
