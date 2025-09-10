//
//  File.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/18/24.
//

import Foundation
class WheelChartModel {
    let chartName: String
    var houseSystemName = ""
    var tropical = true
    var name1 = ""
    var name2 = ""
    var showIndividualCompositeData = false
    var personOneHouseData = [HouseCell]()
    var personTwoHouseData = [HouseCell]()
    var personOnePlanetData = [PlanetCell]()
    var personTwoPlanetData = [PlanetCell]()
    var personOneAspectsData = [TransitCell]()
    var personTwoAspectsData = [TransitCell]()
    var manager: BirthDataManager
    var houseData = [HouseCell]()
    var secondaryHouseData = [HouseCell]()
    var planetData = [PlanetCell]()
    var secondaryPlanetData = [PlanetCell]()
    var aspectsData = [TransitCell]()
    var houseDictionary = [Int: (Int, Signs)]()
    var secondaryHouseDictionary = [Int: (Int, Signs)]()
    var planetsDictionary = [Int: [PlanetCell]]()
    var secondaryPlanetsDictionary = [Int: [PlanetCell]]()
    var planetToDegreeMap = [Planets: Int]()
    var secondaryPlanetToDegreeMap = [Planets: Int]()
    var width: Double = 2
    var height: Double = 2
    let chart: Charts
    var transitTime: Date? = nil
    var birthTime: Date? = nil
    var chartTime = ""
    var selectedTime: Double? = nil
    var selectedLocation: LocationData? = nil
    var calculationSettings: CalculationSettings? =  nil
    var upperPrintingQueue = [((Double, Int), PrintSize)]()
    var lowerPrintingQueue = [((Double, Int), PrintSize)]()
    var natalPrintingQueue = [((Double, Int), PrintSize)]()
    
    init(chartName: String, chart: Charts, manager: BirthDataManager) {
        self.chartName = chartName
        self.chart = chart
        self.manager = manager
    }
}
