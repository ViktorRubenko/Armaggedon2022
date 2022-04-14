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
    }
    enum Colors {
        static let primaryLabelColor: UIColor = .black
    }
}
