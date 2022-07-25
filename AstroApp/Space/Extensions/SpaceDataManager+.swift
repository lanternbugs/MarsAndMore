//
//  SpaceDataManager+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/24/22.
//

import Foundation
import SwiftUI
import CoreData
#if os(macOS)
extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
}
#endif
extension SpaceDataManager {
  
    static var managedContext: NSManagedObjectContext?
    
    func setContextAndLoad(_ context: NSManagedObjectContext) {
        SpaceDataManager.managedContext = context
        if let curiosityDate = getSaveDateOrNil(type: .Curiosity) {
            if curiosityDate != getDateInYYYYMMDD() {
                clearAllPhotoData(type: .Curiosity)
            }
        }
        
        if let opportunityDate = getSaveDateOrNil(type: .Opportunity) {
            if opportunityDate != getDateInYYYYMMDD() {
                clearAllPhotoData(type: .Opportunity)
            }
        }
        
        if let spiritDate = getSaveDateOrNil(type: .Spirit) {
            if spiritDate != getDateInYYYYMMDD() {
                clearAllPhotoData(type: .Spirit)
            }
        }
        
        if let photoOfDayDate = getSaveDateOrNil(type: .NasaPhotoOfDay) {
            if photoOfDayDate != getDateInYYYYMMDD() {
                clearAllPhotoData(type: .NasaPhotoOfDay)
            }
        }
        
        
        if !checkAllDataExists(type: .NasaPhotoOfDay) {
            
            fetchImageOfDay()
        } else {
           imageOfDayData = loadNasaResponse(type: .NasaPhotoOfDay)
        }
        
        if !checkAllDataExists(type: .Curiosity) {
            
            parseManifest(manifest: "curiosity-manifest")
        } else {
           curiosityPhotos = loadNasaResponse(type: .Curiosity)
        }
        
        if !checkAllDataExists(type: .Opportunity) {
            
            parseManifest(manifest: "opportunity-manifest")
        } else {
           opportunityPhotos = loadNasaResponse(type: .Opportunity)
        }
        
        if !checkAllDataExists(type: .Spirit) {
            
            parseManifest(manifest: "spirit-manifest")
        } else {
           spiritPhotos = loadNasaResponse(type: .Spirit)
        }
    }
    
    func clearAllPhotoData(type: NASAPhotoType)
    {
        guard let context = SpaceDataManager.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NASAPhotoData")
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [NASAPhotoData] {
                for photo in photos
                {
                    context.delete(photo)
                    try context.save()
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
    }
    
    func checkAllDataExists(type: NASAPhotoType)->Bool
    {
        guard let context = SpaceDataManager.managedContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NASAPhotoData")
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [NASAPhotoData] {
                if photos.count == type.getMaxPhotos() {
                    return true
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return false
    }
    
    static func getPhotoForKeyOrNil(key: PhotoKey)->UIImage?
    {
        guard let context = SpaceDataManager.managedContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NASAPhotoData")
        let predicate1:NSPredicate = NSPredicate(format: "type == %@", key.type.rawValue)
        let predicate2:NSPredicate = NSPredicate(format: "id == %d", key.id)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2] )
        do {
            if let photos =  try context.fetch(fetchRequest) as? [NASAPhotoData] {
                if(photos.count == 1)
                {
                    for photo in photos
                    {
                        guard let image = photo.image else {
                            return nil
                        }
                        let imageData = image as Data
                        guard let image = UIImage(data: imageData) else {
                            return nil
                        }
                        return image
                    }
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return nil
    }
    
    static func setPhotoForKey(key: PhotoKey, image: UIImage)
    {
        guard let context = SpaceDataManager.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NASAPhotoData")
        let predicate1:NSPredicate = NSPredicate(format: "type == %@", key.type.rawValue)
        let predicate2:NSPredicate = NSPredicate(format: "id == %d", key.id)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2] )
        do {
            if let photos =  try context.fetch(fetchRequest) as? [NASAPhotoData] {
                if(photos.count == 1)
                {
                    for photo in photos
                    {
                        
                        
#if os(macOS)

                        photo.image = image.pngData
#elseif os(iOS)
                        photo.image = image.pngData()
#endif
                        try context.save()
                    }
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
                
            
    }
    
    func getSaveDateOrNil(type: NASAPhotoType)->String?
    {
        guard let context = SpaceDataManager.managedContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NASAPhotoData")
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [NASAPhotoData] {
                for photo in photos
                {
                    guard let date = photo.fetchDate else {
                        return nil
                    }
                    return date
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return nil
    }
    
    func getDateInYYYYMMDD()->String
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func saveNasaResponse(type: NASAPhotoType, data: [ImageInfo])
    {
        guard let context = SpaceDataManager.managedContext else {
            return
        }
        
        let fetchDate = getDateInYYYYMMDD()
        do {
            for image in data
            {
                let nasaImage = NASAPhotoData(context: context)
                nasaImage.type = type.rawValue
                nasaImage.url = image.url
                nasaImage.title = image.title
                nasaImage.id = Int32(image.id)
                nasaImage.descript = image.description
                nasaImage.fetchDate = fetchDate
                try context.save()
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
    }
    
    func loadNasaResponse(type: NASAPhotoType)->[ImageInfo]
    {
        var imageInfo = [ImageInfo]()
        guard let context = SpaceDataManager.managedContext else {
            return imageInfo
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NASAPhotoData")
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [NASAPhotoData] {
                for photo in photos
                {
                    guard let url = photo.url, let descript = photo.descript, let title = photo.title else {
                        return imageInfo
                    }
                    let info = ImageInfo(url: url, description: descript, title: title, id: Int(photo.id))
                    imageInfo.append(info)
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return imageInfo
    }
    
}

