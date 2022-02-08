//
//  CitiesView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var citiesData = BirthDateManager()
    var body: some View {
        List(citiesData.cityInfo?.cities ?? [],id: \.id) {
            city in
            HStack {
                Spacer()
                Text("\(city.city)").frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("\(city.country)").frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            
        }
    }
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView()
    }
}
