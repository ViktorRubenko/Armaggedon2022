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
    func asteroidDetailCellFromResponse(_ response: NearEarthObject, units: Constants.Units) -> [ApproachData]
    func asteroidInfoFromResponse(_ response: NearEarthObject) -> AsteroidInfo
    func dateForRequest(_ date: Date) -> String
}

final class Mapper: MapperProtocol {
    public func asteroidsFromResponse(_ response: ResponseModel) -> [String: AsteroidModel] {
        var asteroids = [AsteroidModel]()
        response.nearEarthObjects.values.forEach{
            asteroids += $0.compactMap{
                let matches = $0.name.match("\\((.*?)\\)")
                let missDistance = AsteroidDistance()
                missDistance.kilometers = Int(round(Double($0.closeApproachData.first!.missDistance.kilometers)!))
                missDistance.lunar = Int(round(Double($0.closeApproachData.first!.missDistance.lunar)!))
                
                return AsteroidModel(
                    name: matches.first != nil ? matches.first! : $0.name,
                    id: $0.id,
                    approachDate: Date(timeIntervalSince1970: TimeInterval($0.closeApproachData.first!.epochDateCloseApproach / 1000)),
                    estimatedDiemeter: avgDiameter($0),
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
        let distance: String
        switch units{
        case .kilometers:
            distance = "\(formatNumber(asteroidModel.missDistance!.kilometers)) км"
        case .lunar:
            distance = "\(formatNumber(asteroidModel.missDistance!.lunar)) лунных орбит"
        }
        return AsteroidCellModel(
            id: asteroidModel.id,
            name: asteroidModel.name,
            distanceString: distance,
            dateString: formatDate(asteroidModel.approachDate),
            diameter: asteroidModel.estimatedDiameter,
            hazardous: asteroidModel.potentiallyHazardouds)
    }
    
    public func asteroidDetailCellFromResponse(_ response: NearEarthObject, units: Constants.Units) -> [ApproachData] {
        response.closeApproachData.compactMap {
                ApproachData(
                    dateString: formatDate(Date(timeIntervalSince1970: TimeInterval($0.epochDateCloseApproach / 1000))),
                    velocity: "\(formatNumber($0.relativeVelocity.kilometersPerHour)) км/ч",
                    distanceString: units == .kilometers ? "\(formatNumber($0.missDistance.kilometers)) км" : "\(formatNumber($0.missDistance.lunar)) лунных орбит",
                    orbitingBody: $0.orbitingBody)
            }
    }
    
    public func asteroidInfoFromResponse(_ response: NearEarthObject) -> AsteroidInfo {
        AsteroidInfo(
            name: response.name,
            diameter: avgDiameter(response),
            hazardous: response.isPotentiallyHazardousAsteroid)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(for: number)!
    }
    
    private func formatNumber(_ number: String) -> String {
        let number = Int(round(Double(number)!))
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
    
    private func avgDiameter(_ object: NearEarthObject) -> Int {
        Int(round(object.estimatedDiameter.meters.estimatedDiameterMin + object.estimatedDiameter.meters.estimatedDiameterMin)) / 2
    }
}
