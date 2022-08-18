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
    
    func checkForNewData()
    {
        if curiosityPhotos.count == ImagePhotoType.Curiosity.getMaxPhotos() {
            if let date = SpaceDataManager.getSaveDateOrNil(type: .Curiosity) {
                if date != SpaceDataManager.getDateInYYYYMMDD() {
                    loadCuriosity()
                }
            }
        }
        
        if opportunityPhotos.count == ImagePhotoType.Opportunity.getMaxPhotos() {
            if let date = SpaceDataManager.getSaveDateOrNil(type: .Opportunity) {
                if date != SpaceDataManager.getDateInYYYYMMDD() {
                    loadOpportunity()
                }
            }
        }
        
        if spiritPhotos.count == ImagePhotoType.Spirit.getMaxPhotos() {
            if let date = SpaceDataManager.getSaveDateOrNil(type: .Spirit) {
                if date != SpaceDataManager.getDateInYYYYMMDD() {
                    loadSpirit()
                }
            }
        }
        
        if imageOfDayData.count == ImagePhotoType.NasaPhotoOfDay.getMaxPhotos() {
            if let date = SpaceDataManager.getSaveDateOrNil(type: .NasaPhotoOfDay) {
                if date != SpaceDataManager.getDateInYYYYMMDD() {
                    loadPictureOfDay()
                }
            }
        }
    }
    
    func loadCuriosity()
    {
        var dateChange = false
        if let curiosityDate = SpaceDataManager.getSaveDateOrNil(type: .Curiosity) {
            if curiosityDate != SpaceDataManager.getDateInYYYYMMDD() {
                dateChange = true
            }
        }
        
        if !SpaceDataManager.checkAllDataExists(type: .Curiosity) || dateChange {
            
            parseManifest(manifest: "curiosity-manifest")
        } else {
           curiosityPhotos = loadNasaResponse(type: .Curiosity)
        }
    }
    
    func loadOpportunity()
    {
        var dateChange = false
        if let opportunityDate = SpaceDataManager.getSaveDateOrNil(type: .Opportunity) {
            if opportunityDate != SpaceDataManager.getDateInYYYYMMDD() {
                dateChange = true
            }
        }
        
        if !SpaceDataManager.checkAllDataExists(type: .Opportunity) || dateChange {
            
            parseManifest(manifest: "opportunity-manifest")
        } else {
           opportunityPhotos = loadNasaResponse(type: .Opportunity)
        }
    }
    
    func loadSpirit()
    {
        var dateChange = false
        if let spiritDate = SpaceDataManager.getSaveDateOrNil(type: .Spirit) {
            if spiritDate != SpaceDataManager.getDateInYYYYMMDD() {
                dateChange = true
            }
        }
        
        if !SpaceDataManager.checkAllDataExists(type: .Spirit) || dateChange {
            
            parseManifest(manifest: "spirit-manifest")
        } else {
           spiritPhotos = loadNasaResponse(type: .Spirit)
        }
    }
    
    func loadPictureOfDay()
    {
        var dateChange = false
        if let photoOfDayDate = SpaceDataManager.getSaveDateOrNil(type: .NasaPhotoOfDay) {
            if photoOfDayDate != SpaceDataManager.getDateInYYYYMMDD() {
                dateChange = true
            }
        }
        
        if !SpaceDataManager.checkAllDataExists(type: .NasaPhotoOfDay) || dateChange {
            
            fetchImageOfDay()
        } else {
           imageOfDayData = loadNasaResponse(type: .NasaPhotoOfDay)
        }
    }
    
    func setContextAndLoad(_ context: NSManagedObjectContext) {
        SpaceDataManager.managedContext = context
        loadCuriosity()
        loadOpportunity()
        loadSpirit()
        loadPictureOfDay()
    }
    
    static func clearAllPhotoData(type: ImagePhotoType, enity: ImageEnities = ImageEnities.Nasa)
    {
        guard let context = SpaceDataManager.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enity.rawValue)
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [GenericImage] {
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
    
    static func checkAllDataExists(type: ImagePhotoType, enity: String = ImageEnities.Nasa.rawValue)->Bool
    {
        guard let context = SpaceDataManager.managedContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enity)
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [GenericImage] {
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: key.enity.rawValue)
        let predicate1:NSPredicate = NSPredicate(format: "type == %@", key.type.rawValue)
        let predicate2:NSPredicate = NSPredicate(format: "id == %d", key.id)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2] )
        do {
            if let photos =  try context.fetch(fetchRequest) as? [GenericImage] {
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: key.enity.rawValue)
        let predicate1:NSPredicate = NSPredicate(format: "type == %@", key.type.rawValue)
        let predicate2:NSPredicate = NSPredicate(format: "id == %d", key.id)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2] )
        do {
            if let photos =  try context.fetch(fetchRequest) as? [GenericImage] {
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
    
    static func getSaveDateOrNil(type: ImagePhotoType, enity: String = ImageEnities.Nasa.rawValue)->String?
    {
        guard let context = SpaceDataManager.managedContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enity)
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [GenericImage] {
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
    
    static func getDateInYYYYMMDD()->String
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func saveNasaResponse(type: ImagePhotoType, data: [ImageInfo])
    {
        guard let context = SpaceDataManager.managedContext else {
            return
        }
        SpaceDataManager.clearAllPhotoData(type: type)
        let fetchDate = SpaceDataManager.getDateInYYYYMMDD()
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
                nasaImage.mediaType = image.mediaType.rawValue
                try context.save()
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
    }
    
    func loadNasaResponse(type: ImagePhotoType)->[ImageInfo]
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
                    guard let url = photo.url, let descript = photo.descript, let title = photo.title, let mediaType = photo.mediaType else {
                        return imageInfo
                    }
                    let info = ImageInfo(url: url, description: descript, title: title, id: Int(photo.id), mediaType: mediaType == MediaType.Video.rawValue ? .Video : .Picture)
                    imageInfo.append(info)
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return imageInfo
    }
    
}

