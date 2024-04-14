//
//  WheelChartPlanetListing.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/10/24.
//

import SwiftUI

struct WheelChartPlanetListing: View {
    let planetData: [PlanetCell]
    let houseData: [HouseCell]
    let chartTitle: String
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(chartTitle).font(.title2)
                Spacer()
            }
            ForEach(planetData.sorted(by: { if $0.planet == .MC && $1.planet == .Ascendent {
                return false
            } else if $0.planet == .Ascendent && $1.planet == .MC {
                return true
            }
               return $0.planet.rawValue < $1.planet.rawValue }), id: \.id) {
                data in
                HStack {
                    if manager.bodiesToShow.contains(data.planet) {
                        if data.planet != .MC && data.planet != .Ascendent {
                            Text(getPlanetRow(data))
                            Spacer()
                        }
                        
                    }
                    
                }
            }
        }
    }
}

extension WheelChartPlanetListing {
    func getPlanetRow(_ data: PlanetCell) -> String {
        var text =  data.planet.getName().uppercased() + " " + data.sign.getName() + " " + data.degree
        if data.retrograde {
            text = text + " " + "R"
        }
        // in house data off for now due to boundary condition between pisces and aries 
        //text = text + getInHouseData(data)
        
        return text
    }
    
    func getInHouseData(_ data: PlanetCell) -> String {
        if houseData.isEmpty {
            return ""
        }
        let num = data.numericDegree
        return " in " + getHouseNumber(num)
    }
    
    func getHouseNumber(_ num: Double) -> String {
        for i in 1...11 {
            if houseData[i - 1].numericDegree > houseData[i].numericDegree {
                if num < houseData[i].numericDegree {
                    if num > houseData[i].numericDegree  - 1 {
                        return "H" + String(i) + "/H" + String(i + 1)
                    }
                    return "H" + String(i)
                } else if num > houseData[i - 1].numericDegree {
                    return "H" + String(i)
                }
            }
            if num >= houseData[i - 1].numericDegree && num < houseData[i].numericDegree {
                if i == 9 && num >= houseData[i].numericDegree - 2.0 {
                    return "H9/10"
                } else if num >= houseData[i].numericDegree - 1.0  {
                    return "H" + String(i) + "/" + String(i + 1)
                }
                    
                else  {
                    if i == 1 {
                        return "H1"
                    }
                    return "H" + String(i)
                }
            }
            
        }
        
        // fix wrap
        if houseData[1].numericDegree < houseData[0].numericDegree {
            return "H12"
        } else if num > houseData[0].numericDegree - 2 && num < houseData[0].numericDegree {
            return "H12/1"
        }
        return "H12"
    }
}

#Preview {
    WheelChartPlanetListing(planetData: [PlanetCell](), houseData: [HouseCell](), chartTitle: "none")
}
