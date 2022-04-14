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
            range: NSRange(location: 0, length: self.utf16.count)) { result, flags, stop in
                if let r = result?.range(at: 1), let range = Range(r, in: self) {
                    results.append(String(self[range]))
                }
            }
        return results
    }
}
