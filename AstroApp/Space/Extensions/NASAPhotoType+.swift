//
//  NASAPhotoType+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/24/22.
//

import Foundation
extension NASAPhotoType {
    func getMaxPhotos()->Int
    {
        switch(self)
        {
        case .NasaPhotoOfDay:
            return 1
        case .Curiosity:
            return 5
        case .Opportunity:
            return 5
        case .Spirit:
            return 5
        }
    }
}
