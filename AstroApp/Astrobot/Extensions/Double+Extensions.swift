/*
*  Copyright (C) 2022 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

import Foundation

extension Double {
    func getAstroSign()->Signs
    {
        let  s = Int(self/30) % 12
        var sign = Signs.None
        if let signType = Signs(rawValue: s) {
            sign = signType
        }
        return sign
    }
    
    func getAstroDegree()->String
    {
        let num = Int(self) % 30
        let difference =  self - Double(Int(self))
        let doubleMinute = difference * 60

        var minute = Int(doubleMinute)
        if 10 * (doubleMinute - Double(minute)) >= 5  {
            minute += 1
        }
        
        return "\(num)° \(minute)'"
    }
    
    func getAstroDegreeWithSeconds()->String
    {
        let num = Int(self) % 30
        let difference =  self - Double(Int(self))
        let doubleMinute = difference * 60

        var minute = Int(doubleMinute)
        let secondDifference = doubleMinute - Double(minute)
        let doubleSecond = secondDifference * 60
        var second = Int(doubleSecond)
        if 10 * (doubleSecond - Double(second)) >= 5  {
            second += 1
        }
        
        return "\(num)° \(minute)' \(second)\""
    }
    
    func getAstroDegreeOnly()->String
    {
        let num = Int(self) % 30
        
        return "\(num)°"
    }
    
    func getAstroMinute()->String
    {
        let difference =  self - Double(Int(self))
        let doubleMinute = difference * 60;

        var minute = Int(doubleMinute)
        if 10 * (doubleMinute - Double(minute)) >= 5  {
            minute += 1
        }
        
        return "\(minute)'"
    }
    
    
    
    func getTransitDegree(with degree2: Double, for aspect: Aspects)->String
    {
        var degree = abs(self - degree2)
        if degree > 180 {
            degree = 360 - degree
        }
        return abs(aspect.rawValue - degree).getAstroDegree()
    }
    
    func getApplying(with degree2: Double, otherDegree: Double, for aspect: Aspects, type: PlanetFetchType)->Movement
    {
        switch(type) {
        case .Transits:
            let initalOrb:Double = getTransitDegree(originalDegree: self, with: otherDegree, for: aspect)
            let laterOrb = getTransitDegree(originalDegree: degree2, with: otherDegree, for: aspect)
            if laterOrb < initalOrb {
                return .Applying
            }
            return .None
        default:
            return .None
        }
    }
    
    private func getTransitDegree(originalDegree: Double, with degree2: Double, for aspect: Aspects)->Double
    {
        var degree = abs(originalDegree - degree2)
        if degree > 180 {
            degree = 360 - degree
        }
        return abs(aspect.rawValue - degree)
    }
    
}
