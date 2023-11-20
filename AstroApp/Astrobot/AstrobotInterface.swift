/*
*  Copyright (C) 2022 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

import Foundation
protocol AstrobotBaseInterface {
    func getPlanets(time: Double, location: LocationData?, calculationSettings: CalculationSettings)->PlanetRow
}

protocol AstrobotInterface: AstrobotBaseInterface {
    func getAspects(time: Double, with time2: Double?, and location: LocationData?, type: OrbType, calculationSettings: CalculationSettings) -> PlanetRow
    func getHouses(time: Double, location: LocationData, system: String, calculationSettings: CalculationSettings) -> PlanetRow
    func getTransitTimes(start_time: Double, end_time: Double, manager: BirthDataManager) -> [TransitTime]
}

protocol AstroRowCell {
    var degree: String { get}
}

struct AstroBot: AstrobotInterface
{
    // used for testing
}

struct CalculationSettings {
    var tropical: Bool = true
    var siderealSystem: SiderealSystem = .Lahiri
    var houseSystem: String = "P"
}
