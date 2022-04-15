//
//  Mapper.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation

protocol MapperProtocol {
    func asteroidsFromResponse(_ response: ResponseModel) -> [String: AsteroidModel]
    func asteroidModelToCellModel(_ asteroidModel: AsteroidModel, units: Constants.Units) -> AsteroidCellModel
    func dateForRequest(_ date: Date) -> String
}

final class Mapper: MapperProtocol {
    public func asteroidsFromResponse(_ response: ResponseModel) -> [String: AsteroidModel] {
        var asteroids = [AsteroidModel]()
        response.nearEarthObjects.values.forEach{
            asteroids += $0.compactMap{
                let missDistance = AsteroidDistance()
                missDistance.kilometers = Int(round(Double($0.closeApproachData.first!.missDistance.kilometers)!))
                missDistance.lunar = Int(round(Double($0.closeApproachData.first!.missDistance.lunar)!))
                
                return AsteroidModel(
                    name: $0.name,
                    id: $0.id,
                    approachDate: Date(timeIntervalSince1970: TimeInterval($0.closeApproachData.first!.epochDateCloseApproach / 1000)),
                    estimatedDiemeter: Int(round($0.estimatedDiameter.meters.estimatedDiameterMin + $0.estimatedDiameter.meters.estimatedDiameterMin)) / 2,
                    potentiallyHazardouds: $0.isPotentiallyHazardousAsteroid,
                    missDistance: missDistance
                    )
            }
        }
        var asteroidsDict = [String: AsteroidModel]()
        asteroids.forEach {
            asteroidsDict[$0.id] = $0
        }
        return asteroidsDict
    }
    
    public func asteroidModelToCellModel(_ asteroidModel: AsteroidModel, units: Constants.Units) -> AsteroidCellModel {
        let matches = asteroidModel.name.match("\\((.*?)\\)")
        let distance: String
        switch units{
        case .kilometers:
            distance = "\(formatNumber(asteroidModel.missDistance!.kilometers)) км"
        case .lunar:
            distance = "\(formatNumber(asteroidModel.missDistance!.lunar)) лунных орбит"
        }
        return AsteroidCellModel(
            id: asteroidModel.id,
            name: matches.first != nil ? matches.first! : asteroidModel.name,
            distanceString: distance,
            dateString: formatDate(asteroidModel.approachDate),
            diameter: asteroidModel.estimatedDiameter,
            hazardous: asteroidModel.potentiallyHazardouds)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        return formatter.string(from: date)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(for: number)!
    }
    
    public func dateForRequest(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
