//
//  Double+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

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
}
