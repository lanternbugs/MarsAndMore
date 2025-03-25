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
import CoreData

//Mark: Core Data functions around Birthdates
extension BirthDataManager {
    
    func setCityUtcOffset(_ zone: TimeZone) {
        cityUtcOffset = nil
        let date = userDateSelection
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonthDate = Calendar.current.date(from: components)!
        let stringDate = startOfMonthDate.getMonthYearDateNoTime()
        DispatchQueue.main.async { [weak self] in
            self?.cityUtcOffset = (Double(zone.secondsFromGMT(for: date)), (String(format: "%.2f", Double(zone.secondsFromGMT(for: date) / 3600)), stringDate))
        }
    }
    
    func addBirthData(data: BirthData) {
        birthDates.append(data)
        addPersonToPersistentStorage(with: data)
    }
    
    func removeUserBirthData(selection: Int?)->Void {
        if let selection = selection {
            guard let context = self.managedContext else {
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BirthDates")
            do {
                if let dates =  try context.fetch(fetchRequest) as? [BirthDates] {
                    for val in dates {
                        if val.name == birthDates[selection].name {
                            context.delete(val)
                            try context.save()
                            birthDates.remove(at: selection)
                            updateIdsOnRemoval(from: selection)
                            return
                        }
                    }
                }
            }
            catch let error as NSError  {
                print("Could not delete \(error), \(error.userInfo)")
                
            }
        }
    }
    
    func updateIdsOnRemoval(from spot: Int)
    {
        for val in spot..<birthDates.count {
            birthDates[val].id -= 1
        }
    }
    
    func updateBirthData(data: BirthData)->Void {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BirthDates")
        do {
            if let birthDates =  try context.fetch(fetchRequest) as? [BirthDates] {
                for val in birthDates {
                    if val.name == data.name {
                        val.year = data.birthDate.year
                        val.month = data.birthDate.month
                        val.day = data.birthDate.day
                        val.time = data.birthTime
                        val.latitude = data.location?.latitude
                        val.longitude = data.location?.longitude
                        try context.save()
                        self.birthDates[data.id] = data
                        return
                    }
                }
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            
        }
    }
    
    func addPersonToPersistentStorage(with data: BirthData) {
        guard let context = self.managedContext else {
            return
        }
        if let entity =  NSEntityDescription.entity(forEntityName: "BirthDates", in: context) {
            let entry = BirthDates(entity: entity, insertInto: context)
            entry.name = data.name
            entry.year = data.birthDate.year
            entry.month = data.birthDate.month
            entry.day = data.birthDate.day
            entry.time = data.birthTime
            if let location = data.location {
                entry.latitude = location.latitude
                entry.longitude = location.longitude
            }
            
            do {
                try context.save()
               }
            catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func loadBirthData() {
        guard birthDates.isEmpty, let context = self.managedContext else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BirthDates")
        do {
            if let birthDates =  try context.fetch(fetchRequest) as? [BirthDates] {
                let dates = birthDates.sorted {
                    if let name1 = $0.name, let name2 = $1.name {
                        return name2 > name1
                    }
                    return true
                }
                for entry in dates {
                    var location: LocationData?
                    if let lat = entry.latitude, let long = entry.longitude {
                       location = LocationData(latitude: lat, longitude: long)
                    }
                    let date = BirthDate(year: entry.year, month: entry.month, day: entry.day)
                    guard let name = entry.name else {
                        continue
                    }
                    let data = BirthData(name: name, birthDate: date, birthTime: entry.time , location: location, id: self.birthDates.count)
                    self.birthDates.append(data)
                    
                }
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
        
    }
    
    func setContext(_ context: NSManagedObjectContext) {
        self.managedContext = context
        addInitialBodyData()
        addInitialAspectData()
        loadUserBodiesToShowInfo()
        loadUserAspectsToShowInfo()
        loadBirthData()
    }
}

//Mark: Core Data functoins around Things to show
extension BirthDataManager {
    
    func addInitialAspectData() {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AspectsVisibility")
        do {
            if let aspects =  try context.fetch(fetchRequest) as? [AspectsVisibility] {
                if aspects.count == 0 {
                    for val in defaultAspectsToShow {
                        addAspectToPersistentStorage(aspect: val)
                    }
                }
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
        
    }
    
    func addAspectToPersistentStorage(aspect: Aspects) -> Void
    {
        guard let context = self.managedContext else {
            return
        }
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AspectsVisibility")
        do {
            if let aspects =  try context.fetch(fetchRequest) as? [AspectsVisibility] {
                let aspectSet: Set<Double> = Set(aspects.map {
                    $0.aspectType
                })
                
                if aspectSet.contains(aspect.rawValue) {
                    return
                }
                let index = aspect.rawValue
                let body =  AspectsVisibility(context: context)
                body.aspectType = index
                try context.save()
                
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
         
      
    }
    
    func removeAspectFromPersistentStorage(aspect: Aspects) -> Void
    {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AspectsVisibility")
        do {
            if let aspects =  try context.fetch(fetchRequest) as? [AspectsVisibility] {
                
                for astroAspect in aspects {
                    if aspect.rawValue == astroAspect.aspectType {
                        context.delete(astroAspect)
                        try context.save()
                        return
                    }
                    
                }
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
    }
    
    func loadUserAspectsToShowInfo()
    {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AspectsVisibility")
        do {
            if let aspects =  try context.fetch(fetchRequest) as? [AspectsVisibility] {
                for aspect in aspects {
                    if let aspectType = Aspects(rawValue: aspect.aspectType) {
                        if aspectsToShow.contains(aspectType) {
                            continue
                        }
                        aspectsToShow.insert(aspectType)
                    }
                }
                
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
    }
    
    func addInitialBodyData() {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bodies")
        do {
            if let bodies =  try context.fetch(fetchRequest) as? [Bodies] {
                if bodies.count == 0 {
                    for val in defaultBodiesToShow {
                        addBodyToPersistentStorage(body: val)
                    }
                }
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
        
    }
    
    func addBodyToPersistentStorage(body: Planets)->Void
    {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bodies")
        do {
            if let bodies =  try context.fetch(fetchRequest) as? [Bodies] {
                let planetSet: Set<Planets?> = Set(bodies.map {
                    if let planet = Planets.getPlanetForAstroIndex(val: $0.planet) {
                        return planet
                    }
                    return nil
                })
                
                if planetSet.contains(body) {
                    return
                }
                let index = body.getAstroIndex()
                let body = Bodies(context: context)
                body.planet = Int32(index)
                try context.save()
                
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
    }
    
    func removeBodyFromPersistentStorage(body: Planets)->Void
    {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bodies")
        do {
            if let bodies =  try context.fetch(fetchRequest) as? [Bodies] {
                
                for astroBody in bodies {
                    if let planet = Planets.getPlanetForAstroIndex(val: astroBody.planet) {
                        if planet == body {
                            context.delete(astroBody)
                            try context.save()
                            return
                        }
                    }
                    
                }
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
    }
    
    func loadUserBodiesToShowInfo()
    {
        guard let context = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bodies")
        do {
            if let bodies =  try context.fetch(fetchRequest) as? [Bodies] {
                for body in bodies {
                    if let planet = Planets.getPlanetForAstroIndex(val: body.planet) {
                        if bodiesToShow.contains(planet) {
                            continue
                        }
                        bodiesToShow.insert(planet)
                    }
                }
                
            }
        }
        catch let error as NSError  {
                    print("Could not load \(error), \(error.userInfo)")
        }
    }
}

//Mark: Astrobot Functionality
extension BirthDataManager {
    func getSelectionTime()->Double {
        if let index = self.selectedName {
            let data = self.birthDates.first {
                $0.id == index
            }
            guard let data = data else {
                return Date().getAstroTime()
            }
            return data.getAstroTime()
        }
        return Date().getAstroTime()
    }
    
    func getSelectionLocation()->LocationData?
    {
        if let index = self.selectedName {
            let data = self.birthDates.first {
                $0.id == index
            }
            guard let data = data else {
                return nil
            }
            return data.location
        }
        return nil
    }
}
