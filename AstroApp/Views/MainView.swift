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

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("currentTab") private var currentTab: Int = 0
    @StateObject private var birthDataManager = BirthDataManager()
    @StateObject private var planetsDate = PlanetsDate()
    @State private var roomState: RoomState = .Chart
    @State private var planetsState: RoomState = .Chart
    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
               MarsTab()
                    .tabItem {
                        Text("Mars Room")
                    }
                    .tag(0)
                ChartTab()
                    .tabItem {
                    Text("Charts")
                    }
                .tag(1)
                .environmentObject(birthDataManager)
                .environment(\.roomState, $roomState)
                PlanetsTab()
                    .tabItem {
                    Text("Planets")
                    }
                    .environmentObject(birthDataManager)
                    .environmentObject(planetsDate)
                    .environment(\.roomState, $planetsState)
                .tag(2)
            }
        }.onAppear {
            birthDataManager.setContext(_viewContext.wrappedValue)
        }
    }
}

class PlanetsDate: ObservableObject {
    @Published var planetsDateChoice = Date();
    @Published var exactPlanetsTime = false
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
