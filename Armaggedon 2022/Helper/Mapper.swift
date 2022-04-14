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
                    approachDate: Date(timeIntervalSince1970: TimeInterval($0.closeApproachData.first!.epochDateCloseApproach / 1000)),
                    estimatedDiameter: Int(round($0.estimatedDiameter.meters.estimatedDiameterMin + $0.estimatedDiameter.meters.estimatedDiameterMin)) / 2,
                    potentiallyHazardouds: $0.isPotentiallyHazardousAsteroid,
                    missDistance: AsteroidDistance(
                        kilometers: Int(round(Double($0.closeApproachData.first!.missDistance.kilometers)!)),
                        lunar: Int(round(Double($0.closeApproachData.first!.missDistance.lunar)!))))
            }
        })
        
    }
    
    public func asteroidModelToCellModel(_ asteroidModel: AsteroidModel, units: String = "KM") -> AsteroidCellModel {
        let matches = asteroidModel.name.match("\\((.*?)\\)")
        let distance = "\(formatNumber(asteroidModel.missDistance.kilometers)) км"
        return AsteroidCellModel(
            name: matches.first != nil ? matches.first! : asteroidModel.name,
            distanceString: distance,
            dateString: formatDate(asteroidModel.approachDate),
            diameter: asteroidModel.estimatedDiameter,
            hazardous: asteroidModel.potentiallyHazardouds)
    }
    
    public func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        return formatter.string(from: date)
    }
    
    public func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(for: number)!
    }
}
