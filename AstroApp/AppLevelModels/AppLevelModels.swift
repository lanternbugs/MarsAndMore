//
//  AppLevelModels.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/11/22.
//

import Foundation
enum RoomState: Equatable {
    case Entry
    case Chart
    case Planets
    case Names
    case EditName
    case Cities
    case UpdateCity
    case ChartSettings
    case Resources
    case Reading(planet: Planets, sign: Signs)
    case Space
    case Picture
    case Art
    case Library
}

enum AppTab: Int {
    case MarsTab, ChartTab, PlanetsTab, SpaceTab, ArtTab
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

