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

struct CitiesView: View {
    @EnvironmentObject var citiesData:BirthDataManager
    @State private var city = ""
    var displayCities: [City] {
        if let  cities = citiesData.cityInfo?.cities
        {
            let data = cities.filter {
                if cities.isEmpty {
                    return true
                }
                return $0.name.lowercased().hasPrefix(city.lowercased())
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
                    Text("\(city.name)").frame(maxWidth: .infinity, alignment: .leading)
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
