//
//  SpaceModels.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/16/22.
//

import Foundation
struct ImageInfo {
    let url: URL
    let description: String
    let title: String
    let id: Int
}

struct PictureOfDay: Codable
{
    let date: String?
    let explanation: String
    let hdurl: URL?
    let media_type: String?
    let service_version: String?
    let title: String
    let url: URL
}

struct RoverManifest: Codable
{
    let photo_manifest: ManifestData
}
struct ManifestData: Codable
{
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
    let max_sol: Int
    let max_date: String
    let total_photos: Int
    let photos: [PhotoData]
}

struct PhotoData: Codable
{
    let sol: Int
    let earth_date: String
    let total_photos: Int
    let cameras:Array<String>
}
struct RoverPhotos: Codable
{
    var photos: [RoverPhoto]
}

struct RoverPhoto: Codable
{
    var id: Int
    var sol: Int
    var camera: RoverCamera
    var img_src: URL
    var earth_date: String
    var rover: Rover
    
    
}

struct RoverCamera: Codable
{
    var id: Int
    var name: String
    var rover_id: Int
    var full_name: String
}

struct Rover: Codable
{
    var id: Int
    var name: String
    var landing_date: String
    var launch_date: String
    var status: String
}

enum  NASAPhotoType:String {
    case NasaPhotoOfDay, Curiosity, Opportunity, Spirit
}

struct PhotoKey
{
    let type: NASAPhotoType
    let id: Int
}
