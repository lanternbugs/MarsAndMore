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
