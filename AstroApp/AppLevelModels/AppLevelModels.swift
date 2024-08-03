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
indirect enum RoomState: Equatable {
    static func == (lhs: RoomState, rhs: RoomState) -> Bool {
        lhs.getName() == rhs.getName()
    }
    
    case Entry
    case Chart
    case Planets
    case Names(onDismiss: RoomState)
    case EditName(onDismiss: RoomState)
    case Cities(onDismiss: RoomState)
    case UpdateCity
    case PlanetsCity
    case ChartSettings
    case Resources
    case Reading(planet: Planets, sign: Signs)
    case Space
    case Picture
    case Art
    case Library
    case Mundane(transits: [TransitTime], date: Date)
    case TransitsView(transits: [TransitTime], skyTransits: [TransitTime], date: Date, chartName: String, transitData: TransitTimeData)
    case NatalView(onDismiss: RoomState, viewModel: ChartViewModel)
    case About
    case Mars
    case SynastryChooser
    case Ephemeris
}

enum AppTab: Int {
    case MarsTab, ChartTab, PlanetsTab, SpaceTab, ArtTab
}

enum Charts {
    case Natal, Transit, Synastry
}

enum ChartWheelColorType: Int {
    case Light, Dark
}

enum  ImagePhotoType:String {
    case NasaPhotoOfDay, Curiosity, Opportunity, Spirit, MarsArt, VenusArt, Library
}

enum ImageEnities: String { case Nasa = "NASAPhotoData", Met = "MetArtImage" }

struct PhotoKey
{
    let type: ImagePhotoType
    let id: Int
    let enity: ImageEnities
}

enum JPEGQuality: Float {
    case lowest  = 0.2
    case low     = 0.4
    case medium  = 0.6
    case high    = 0.8
    case highest = 1
}

