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
}

enum AppTab: Int {
    case MarsTab, ChartTab, PlanetsTab, SpaceTab, ArtTab
}

enum  ImagePhotoType:String {
    case NasaPhotoOfDay, Curiosity, Opportunity, Spirit, MarsArt, VenusArt
}

enum ImageEnities: String { case Nasa = "NASAPhotoData", Met = "MetArtImage" }

struct PhotoKey
{
    let type: ImagePhotoType
    let id: Int
    let enity: ImageEnities
}

