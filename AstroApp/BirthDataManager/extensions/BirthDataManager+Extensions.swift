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
        loadBirthData()
    }
}

//Mark: Core Data functoins around Bodies to show
extension BirthDataManager {
    func addBodyToPersistentStorage(body: Planets)->Void
    {
        
    }
    
    func removeBodyFromPersistentStorage(body: Planets)->Void
    {
        
    }
    
    func loadUserBodiesToShowInfo()
    {
        
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
