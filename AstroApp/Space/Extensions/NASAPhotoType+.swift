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
extension ImagePhotoType {
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
        case .MarsArt:
            return 5
        case .VenusArt:
            return 5
        case .Library:
            return Int.max
        }
    }
}
