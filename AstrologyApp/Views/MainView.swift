//
//  MainView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("currentTab") private var currentTab: Int = 0
    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
               MarsRoom()
                    .tabItem {
                        Text("Mars Room")
                    }
                    .tag(0)
                    .onAppear() {
                        self.currentTab = 0
                    }
                ChartRoom()
                    .tabItem {
                    Text("Chart Room")
                }
                .tag(1)
                .onAppear() {
                    self.currentTab = 1
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
