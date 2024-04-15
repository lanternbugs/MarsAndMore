//
//  WheelChartAspectsListing.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/14/24.
//

import SwiftUI

struct WheelChartAspectsListing: View {
    let chart: Charts
    let aspectsData: [TransitCell]
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if chart == .Synastry || chart == .Natal {
                    Text("Aspects").font(.title2)
                } else {
                    Text("Transits").font(.title2)
                }
                
                Spacer()
            }
            ForEach(getAspectsData(), id: \.id) {
                data in
                HStack {
                    if data.aspect.isMajor() && manager.bodiesToShow.contains(data.planet) && manager.bodiesToShow.contains(data.planet2){
                        Text(getAspectRow(data))
                        Spacer()
                    }
                    
                }
            }
            if chart == .Transit {
                Text("")
                HStack {
                    Text("* for Applying").font(.title3)
                    Spacer()
                }
            }
        }
    }
}

extension WheelChartAspectsListing {
    func getAspectsData() -> [TransitCell] {
        if chart == .Natal {
            return aspectsData.sorted(by: {
                if  $0.planet.rawValue < $1.planet.rawValue {
                    if $0.planet.rawValue < $1.planet2.rawValue {
                        return true
                    } else {
                        if $0.planet2.rawValue < $1.planet2.rawValue {
                            return true
                        }
                        return false
                    }
                } else {
                    if $0.planet2.rawValue < $1.planet.rawValue {
                        if $0.planet2.rawValue < $1.planet2.rawValue {
                            return true
                        }
                        return false
                    } else {
                        if $1.planet.rawValue < $0.planet.rawValue {
                            return false
                        }
                        return false
                    }
                }
                        
                        
            })
        }
        if chart == .Synastry {
            return aspectsData.sorted(by: {
                if $0.planet2 == .MC && $1.planet2 == .Ascendent  {
                    return false
                }
                if $0.planet2 == .Ascendent && $1.planet2 == .MC  {
                    return true
                }
                return $0.planet2.rawValue < $1.planet2.rawValue })
        }
        return aspectsData.sorted(by: {
            return $0.planet.rawValue < $1.planet.rawValue })
    }
    
    func getAspectRow(_ data: TransitCell) -> String {
        if chart == .Transit {
            var tempo =   data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
            if data.movement == .Applying {
                tempo = "*" + tempo
            }
            return tempo
        }
        if chart == .Natal {
            if data.planet.rawValue < data.planet2.rawValue {
                return data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
            } else {
                return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
            }
        }
        return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
    }
}

#Preview {
    WheelChartAspectsListing(chart: .Natal, aspectsData: [TransitCell]())
}
