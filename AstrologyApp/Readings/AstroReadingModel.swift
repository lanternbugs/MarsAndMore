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
    case Names
    case Cities
    case Reading(planet: Planets, sign: Signs)
}
struct ReadingEntry {
    let text: String
    let id: Int
}
protocol AstroReading {
    func getReading()-> [ReadingEntry]
}

protocol AstrobotReadingInterface: AstrobotBaseInterface  {
    func getPlanet(type: Planets, time: Double)->ReadingState
}
