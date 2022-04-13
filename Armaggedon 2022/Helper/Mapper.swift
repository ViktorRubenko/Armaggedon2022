//
//  Mapper.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation

final class Mapper {
    public func asteroidsFromResponse(_ response: ResponseModel) -> [AsteroidModel] {
        return response.nearEarthObjects.values.reduce([AsteroidModel](), { partialResult, nearEarthObjects in
            partialResult + nearEarthObjects.compactMap {
                AsteroidModel(
                    name: $0.name,
                    id: $0.id,
                    approachDate: Date(timeIntervalSince1970: TimeInterval($0.closeApproachData.first!.epochDateCloseApproach)),
                    estimatedDiameter: Int(round($0.estimatedDiameter.meters.estimatedDiameterMin + $0.estimatedDiameter.meters.estimatedDiameterMin)) / 2,
                    potentiallyHazardouds: $0.isPotentiallyHazardousAsteroid,
                    missDistance: AsteroidDistance(
                        kilometers: Int(round(Double($0.closeApproachData.first!.missDistance.kilometers)!)),
                        lunar: Int(round(Double($0.closeApproachData.first!.missDistance.lunar)!))))
            }
        })
        
    }
}
