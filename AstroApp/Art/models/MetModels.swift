//
//  MetModels.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/10/22.
//

import Foundation

struct MetImage: Codable {
    let objectID: Int
    let isHighLight: String?
    let accessionNumber: String?
    let accessionYear: String?
    let isPublicDomain: Bool?
    let primaryImage: String?
    let primaryImageSmall: String?
    let additionalImages: [String?]
    let constituents: [Constituents]?
    let department: String?
    let objectName: String?
    let title: String?
    let culture: String?
    let period: String?
    let dynasty: String?
    let reign: String?
    let portfolio: String?
    let artistRole: String?
    let artistPrefix: String?
    let artistDisplayName: String?
    let artistDisplayBio: String?
    let artistSuffix: String?
    let artistAlphaSort: String?
    let artistNationality: String?
    let artistBeginDate: String?
    let artistEndDate: String?
    let artistGender: String?
    let artistWikidata_URL: String?
    let artistULAN_URL: String?
    let objectDate: String?
    let objectBeginDate: Int?
    let objectEndDate: Int?
    let medium: String?
    let dimensions: String?
    let measurements: [Measurements]?
    let creditLine: String?
    let geographyType: String?
    let city: String?
    let state: String?
    let county: String?
    let region: String?
    let subregion: String?
    let local: String?
    let locus: String?
    let excavation: String?
    let river: String?
    let classification: String?
    let rightsAndReproduction: String?
    let linkResource: String?
    let metadataDate: String?
    let repository: String?
    let objectURL: String?
    let tags: [Tags]?
    let objectWikidata_URL: String?
    let isTimelineWork: Bool?
    let GalleryNumber: String?
}

struct Constituents: Codable
{
    let constituentID: Int?
    let role: String?
    let name: String?
    let constituentULAN_URL: String?
    let constituentWikidata_URL: String?
    let gender: String?
}



struct Measurements: Codable
{
    let elementName: String?
    let elementDescription: String?
    let elementMeasurements: ElementMeasurements
}

struct ElementMeasurements: Codable
{
    let Depth: Float?
    let Height: Float?
    let Width: Float?
}

struct Tags: Codable
{
    let term: String?
    let AAT_URL: String?
    let Wikidata_URL: String?
}

struct MetImageData
{
    let objectId: Int
    let name: String
    let artistDisplayName: String?
    let objectDate: String?
    let objectName: String?
    let url: URL
    let id: String
}

enum FailureReason : Error {
    case sessionFailed(error: URLError)
    case decodingFailed
    case other(Error)
}
