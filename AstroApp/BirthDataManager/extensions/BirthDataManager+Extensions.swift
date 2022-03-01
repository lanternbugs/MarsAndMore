//
//  BirthDataManager+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/28/22.
//

import Foundation
import CoreData

//Mark: Core Data functions
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
            entry.id = Int32(data.id)
            entry.name = data.name
            entry.year = data.birthDate.year
            entry.month = data.birthDate.month
            entry.day = data.birthDate.day
            entry.time = data.birthTime
            if let locatoin = data.location {
                entry.latitude = locatoin.latitude
                entry.longitude = locatoin.longitude
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
                for entry in birthDates {
                    var location: LocationData?
                    if let lat = entry.latitude, let long = entry.longitude {
                       location = LocationData(latitude: lat, longitude: long)
                    }
                    let date = BirthDate(year: entry.year, month: entry.month, day: entry.day)
                    guard let name = entry.name else {
                        continue
                    }
                    let data = BirthData(name: name, birthDate: date, birthTime: entry.time , location: location, id: Int(entry.id))
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
