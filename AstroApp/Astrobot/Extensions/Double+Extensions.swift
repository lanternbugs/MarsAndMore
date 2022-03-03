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
        let s = (Int(self/30))%12
        let num = Int(self - (Double(s) * 30))

        let intSelf = Int(self)
        let difference =  self - Double(intSelf)
        let fraction = difference * 3600;

        let minute1 = fraction / 60;
        var minute = Int(fraction / 60)
        if 10 * (minute1 - Double(minute)) >= 5  {
            minute += 1
        }
        
        return "\(num)° \(minute)'"
    }
    
    func getTransitDegree(with degree2: Double, for aspect: Aspects)->String
    {
        var degree = abs(self - degree2)
        if degree > 180 {
            degree = 360 - degree
        }
        return abs(aspect.rawValue - degree).getAstroDegree()
    }
    
    func getApplying(with degree2: Double, otherDegree: Double, for aspect: Aspects)->Movement {
        
        let initalOrb:Double = getTransitDegree(originalDegree: self, with: otherDegree, for: aspect)
        let laterOrb = getTransitDegree(originalDegree: degree2, with: otherDegree, for: aspect)
        if laterOrb < initalOrb {
            return .Applying
        }
        return .None
    }
    
    func getTransitDegree(originalDegree: Double, with degree2: Double, for aspect: Aspects)->Double
    {
        var degree = abs(originalDegree - degree2)
        if degree > 180 {
            degree = 360 - degree
        }
        return abs(aspect.rawValue - degree)
    }
    
}
