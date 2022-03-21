//
//  SelectedNameView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/15/22.
//

import SwiftUI

struct SelectedNameView: View {
    @EnvironmentObject var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @ViewBuilder
    var body: some View {
        if let selection = manager.selectedName {
            VStack {
                Text(manager.birthDates[selection].name).namesStyle()
                    .selectedNameColor()
                    .gesture(TapGesture().onEnded({
                        tappedSelectedName()
                }))
                
                Button(action: {
                    setSelectedNameData()
                    roomState.wrappedValue = .EditName
                }) {
                    Text("Edit").font(.headline).padding([.leading, .trailing]).selectedNameColor()
                }
            }
            
        } else {
            Text("No selection")
        }
        
    }
}


extension SelectedNameView {
    func tappedSelectedName()->Void {
        manager.selectedName = nil
    }
    
    func setSelectedNameData()->Void {
        if let index = manager.selectedName {
            manager.userNameSelection = manager.birthDates[index].name
            if let time =  manager.birthDates[index].birthTime {
                manager.userExactTimeSelection = true
                manager.userDateSelection = time
                if let location = manager.birthDates[index].location {
                    manager.userLocationData = location
                }
            } else {
                manager.userExactTimeSelection = false
                setTimeFromBirthdate(from: index)
                
            }
        }
    }
    
    func setTimeFromBirthdate(from index: Int)
    {
        var dateComponents = DateComponents()
        dateComponents.year = Int(manager.birthDates[index].birthDate.year)
        dateComponents.month = Int(manager.birthDates[index].birthDate.month)
        dateComponents.day = Int(manager.birthDates[index].birthDate.day)
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = 12
        dateComponents.minute = 0

        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian)
        if let time = userCalendar.date(from: dateComponents) {
            manager.userDateSelection = time
        }
    }
}
struct SelectedNameView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedNameView()
    }
}
