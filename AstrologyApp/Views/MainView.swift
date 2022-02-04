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
                    
                    .onAppear() {
#if os(iOS)
                        currentTab = 0
#endif
                    }
                    .tag(0)
                ChartRoom()
                    .tabItem {
                    Text("Chart Room")
                }
                
                .onAppear() {
#if os(iOS)
                    currentTab = 1
#endif
                }
                .tag(1)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
