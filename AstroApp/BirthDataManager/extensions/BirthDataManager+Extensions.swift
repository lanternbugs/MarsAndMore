//
//  BirthDataManager+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/28/22.
//

import Foundation
import CoreData

//Mark: Core Data functions around Birthdates
extension BirthDataManager {
    
    func addBirthData(data: BirthData) {
        birthDates.append(data)
        addPersonToPersistentStorage(with: data)
    }
    
    func removeUserBirthData(selection: Int?)->Void {
        if let selection = selection {
            birthDates.remove(at: selection)
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
        loadUserBodiesToShowInfo()
        loadBirthData()
    }
}

//Mark: Core Data functoins around Bodies to show
extension BirthDataManager {
    
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
