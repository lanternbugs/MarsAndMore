//
//  EditLocationDataViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 10/7/24.
//

import Foundation

class EditLocationDataViewModel {
    var latDegreeChoices = [(Int, Int)]()
    var latMinuteChoices = [(Int, Int)]()
    var latSecondChoices = [(Int, Int)]()
    var longDegreeChoices = [(Int, Int)]()
    var longMinuteChoices = [(Int, Int)]()
    var longSecondChoices = [(Int, Int)]()
    var latitudeDirection = ["N", "S"]
    var longitudeDirection = ["E", "W"]
    let latDegreeOffset = 100
    let latMinuteOffset = 1000
    let latSecondOffset = 10000
    let longDegreeOffset = 200
    let longMinuteOffset = 2000
    let longSecondOffset = 20000
    
    init() {
        populateChoices()
    }
    
    func populateChoices() {
        for i in 0...59 {
            latDegreeChoices.append((i, i + latDegreeOffset))
            latMinuteChoices.append((i, i + latMinuteOffset))
            latSecondChoices.append((i, i + latSecondOffset))
            longDegreeChoices.append((i, i + longDegreeOffset))
            longMinuteChoices.append((i, i + longMinuteOffset))
            longSecondChoices.append((i, i + longSecondOffset))
        }
    }
}
