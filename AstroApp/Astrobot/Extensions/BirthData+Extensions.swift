//
//  File.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/14/22.
//

import Foundation
extension BirthData {
    func getAstroTime()->Double {
        
        if let time = self.birthTime {
            return time.getAstroTime()
        }
        let adapter = AdapterToEphemeris()
        let h = 12
        let min = 0
        
        return Double(adapter.getSweJulianDay(self.birthDate.year, self.birthDate.month, self.birthDate.day, Double(h + min / 60)))
    }
}
