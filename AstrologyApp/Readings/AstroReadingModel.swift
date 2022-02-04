//
//  AstroReadingModel.swift
//  MarsAndMore (iOS)
//
//  Created by Michael Adams on 2/3/22.
//

import Foundation

enum ReadingState {
    case Entry
    case Chart
    case Reading(planet: Planets, sign: Signs)
}
struct ReadingEntry {
    let text: String
    let id: Int
}
protocol AstroReading {
    func getReading()-> [ReadingEntry]
}
