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
    var latitudeDirections = ["N", "S"]
    var longitudeDirections = ["E", "W"]
    let latDegreeOffset = 100
    let latMinuteOffset = 1000
    let latSecondOffset = 10000
    let longDegreeOffset = 500
    let longMinuteOffset = 2000
    let longSecondOffset = 20000
    var manager: BirthDataManager
    var editMode = false
    enum MeasurementTypes { case latDirection, latDegree, latMinute, latSecond, longDirection, longDegree, longMinute, longSecond }
    
    var latitudeDirection: String {
        let value = getValue(type: MeasurementTypes.latDirection)
        if value == -1 {
            return "S"
        }
        return "N"
    }
    var longitudeDirection: String {
        let value = getValue(type: MeasurementTypes.longDirection)
        if value == -1 {
            return "W"
        }
        return "E"
    }
    var latitudeDegree: Int {
        getValue(type: MeasurementTypes.latDegree)
    }
    var longitudeDegree: Int {
        getValue(type: MeasurementTypes.longDegree)
    }
    
    var latitudeMinute: Int {
        getValue(type: MeasurementTypes.latMinute)
    }
    var longitudeMinute: Int {
        getValue(type: MeasurementTypes.longMinute)
    }
    
    var latitudeSecond: Int {
        getValue(type: MeasurementTypes.latSecond)
    }
    var longitudeSecond: Int {
        getValue(type: MeasurementTypes.longSecond)
    }
    
    var dismissState: RoomState {
        if editMode {
            return RoomState.EditName(onDismiss: .Chart)
        }
        return RoomState.Names(onDismiss: .Chart)
    }
    
    init(manager: BirthDataManager) {
        self.manager = manager
        populateChoices()
    }
    
    func getValue(type: MeasurementTypes) -> Int {
        
        var latitude: Double = 0
        var longitude: Double = 0
        if editMode {
            if let locationData = manager.userLocationData {
                latitude = locationData.latitude.getLatLongAsDouble()
                longitude = locationData.longitude.getLatLongAsDouble()
            }
        } else {
            if let city = manager.builder.cityData {
                latitude = city.latitude.getLatLongAsDouble()
                longitude = city.longitude.getLatLongAsDouble()
            }
        }
        if type == .latDirection {
            return latitude < 0 ? -1 : 0
        } else if type == .longDirection {
            return longitude < 0 ? -1 : 0
        } else if type == .latDegree {
            return abs(Int(latitude)) + latDegreeOffset
        } else if type == .longDegree {
            return abs(Int(longitude)) + longDegreeOffset
        } else if type == .latMinute {
            return getMinutes(latitude) + latMinuteOffset
        }  else if type == .longMinute {
            return getMinutes(longitude) + longMinuteOffset
        } else if type == .latSecond {
            return getSeconds(latitude) + latSecondOffset
        }  else if type == .longSecond {
            return getSeconds(longitude) + longSecondOffset
        }
        
        return 0
    }
    
    func getMinutes(_ value: Double) -> Int {
        let degree = abs(Int(value))
        let decimalDiff = abs(value) - Double(degree)
        return Int(decimalDiff * 60.0)
    }
    
    func getSeconds(_ value: Double) -> Int {
        let degree = abs(Int(value))
        let decimalDiff = abs(value) - Double(degree)
        let minutes = getMinutes(value)
        let secondsDiff = decimalDiff - Double(minutes) / 60.0
        let seconds = Int((secondsDiff * 3600.00).rounded())
        if seconds > 59 {
            return 59
        }
        return seconds
    }
    
    func setMode(editMode: Bool) {
        self.editMode = editMode
    }
    
    func populateChoices() {
        for i in 0...59 {
            latMinuteChoices.append((i, i + latMinuteOffset))
            latSecondChoices.append((i, i + latSecondOffset))
            longMinuteChoices.append((i, i + longMinuteOffset))
            longSecondChoices.append((i, i + longSecondOffset))
        }
        for i in 0...89 {
            latDegreeChoices.append((i, i + latDegreeOffset))
        }
        for i in 0...179 {
            longDegreeChoices.append((i, i + longDegreeOffset))
        }
    }
    
    func submit(latDirection: String, latDegree: Int, latMinute: Int, latSecond: Int, longDirection: String, longDegree: Int, longMinute: Int, longSecond: Int)
    {
        var latitude = String(latDegree - latDegreeOffset) + "° " + String(latMinute - latMinuteOffset) + "' " + String(latSecond - latSecondOffset) + "\""
        var longitude = String(longDegree - longDegreeOffset) + "° " + String(longMinute - longMinuteOffset) + "' " + String(longSecond - longSecondOffset) + "\""
        if latDirection == "S" {
            latitude = "-" + latitude
        }
        if longDirection == "W" {
            longitude = "-" + longitude
        }
        let city = City(city: "Custom", country: "Custom", latitude: latitude, longitude: longitude, id: 0)
        manager.builder.removeLocation()
        manager.userLocationData = nil
        manager.builder.addCity(city)
        
        
    }
}
