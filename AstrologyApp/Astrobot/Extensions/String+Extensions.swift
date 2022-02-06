//
//  String+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/5/22.
//

import Foundation
extension String {
    func convertToTwentyFourHours()->String
    {
        if self.contains("PM") {
            let hour = self.replacingOccurrences(of: "PM", with: "")
            if let intHour = Int(hour)
            {
                return String(intHour + 12)
            }
        }
        return self.replacingOccurrences(of: "AM", with: "")
    }
}
