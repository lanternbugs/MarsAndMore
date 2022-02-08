//
//  CitiesView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var citiesData = BirthDateManager()
    @State private var city = ""
    var displayCities: [City] {
        if let  cities = citiesData.cityInfo?.cities
        {
            let data = cities.filter {
                if cities.isEmpty {
                    return true
                }
                return $0.city.lowercased().hasPrefix(city.lowercased())
            }
            return data
        }
        return [City]()
         
    }
    var body: some View {
        VStack(alignment: .leading) {
            // text could be in search bar with searchable but this is to work in ios 14 too
            Text("Cities").font(.title.weight(.bold))
            TextField("City", text: $city)
            List(displayCities, id: \.id) {
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
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView()
    }
}
