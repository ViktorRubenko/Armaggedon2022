//
//  Extensions.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 14.04.2022.
//

import UIKit

extension UILabel {
    class func defaultLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = Constants.Colors.primaryLabelColor
        return label
    }
}

extension String {
    func match(_ pattern: String) -> [String] {
        var results = [String]()
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        regex.enumerateMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count)) { result, _, _ in
                if let match = result?.range(at: 1), let range = Range(match, in: self) {
                    results.append(String(self[range]))
                }
            }
        return results
    }
}

extension UserDefaults {
    @objc var units: String {
        get {
            string(forKey: "units") ?? Constants.Units.kilometers.rawValue
        }

        set {
            set(newValue, forKey: "units")
        }
    }

    @objc var onlyHazardous: Bool {
        get {
            bool(forKey: "onlyHazardous")
        }
        set {
            set(newValue, forKey: "onlyHazardous")
        }
    }
}
