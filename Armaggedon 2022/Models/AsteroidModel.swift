//
//  AsteroidModel.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import Foundation
import RealmSwift

final class AsteroidModel: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var approachDate = Date()
    @objc dynamic var estimatedDiameter = 0
    @objc dynamic var potentiallyHazardouds = false
    @objc dynamic var missDistance: AsteroidDistance?

    override class func primaryKey() -> String? {
            return "id"
        }

    convenience init(
        name: String,
        id: String,
        approachDate: Date,
        estimatedDiemeter: Int,
        potentiallyHazardouds: Bool,
        missDistance: AsteroidDistance
    ) {
        self.init()
        self.name = name
        self.id = id
        self.approachDate = approachDate
        self.estimatedDiameter = estimatedDiemeter
        self.potentiallyHazardouds = potentiallyHazardouds
        self.missDistance = missDistance
    }
}

final class AsteroidDistance: Object {
    @objc dynamic var kilometers = 0
    @objc dynamic var lunar = 0
}
