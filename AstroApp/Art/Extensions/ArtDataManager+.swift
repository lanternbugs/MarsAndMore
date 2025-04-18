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
#if os(iOS)
import UIKit
#endif
extension ArtDataManager {
    static var managedContext: NSManagedObjectContext?
    
    func setContextAndLoad(_ context: NSManagedObjectContext) {
        ArtDataManager.managedContext = context
        //SpaceDataManager.clearAllPhotoData(type: .VenusArt, enity: ImageEnities.Met)
        //SpaceDataManager.clearAllPhotoData(type: .MarsArt, enity: ImageEnities.Met)
        loadVenusArt()
        loadMarsArt()
        libraryData = loadArtResponse(type: .Library)
    }
    
    func checkForNewData()
    {
        if !venusSearchOngoing, let date = SpaceDataManager.getSaveDateOrNil(type: .VenusArt, enity: ImageEnities.Met.rawValue) {
            if date != SpaceDataManager.getDateInYYYYMMDD() {
                loadVenusArt()
            }
        }
        
        if !marsSearchOngoing, let date = SpaceDataManager.getSaveDateOrNil(type: .MarsArt, enity: ImageEnities.Met.rawValue) {
            if date != SpaceDataManager.getDateInYYYYMMDD() {
                loadMarsArt()
            }
        }
    }
    
    func loadVenusArt()
    {
        var dateChange = false
        if let date = SpaceDataManager.getSaveDateOrNil(type: .VenusArt, enity: ImageEnities.Met.rawValue) {
            if date != SpaceDataManager.getDateInYYYYMMDD() {
                dateChange = true
            }
        }
        
        if !SpaceDataManager.checkAllDataExists(type: .VenusArt, enity: ImageEnities.Met.rawValue) || dateChange {
            tempVenusArtData.removeAll()
            venusSearchOngoing = true
            if SpaceDataManager.checkAllDataExists(type: .VenusArt, enity: ImageEnities.Met.rawValue) {
                loadVenusArt(objects: getRandomArtObjects(objects: venusObjects))
                venusArtData = loadArtResponse(type: .VenusArt)
            } else {
                loadVenusArt(objects: getRandomArtObjects(objects: venusObjects))
            }
        } else {
           venusArtData = loadArtResponse(type: .VenusArt)
        }
    }
    
    func loadMarsArt()
    {
        
        var dateChange = false
        if let date = SpaceDataManager.getSaveDateOrNil(type: .MarsArt, enity: ImageEnities.Met.rawValue) {
            if date != SpaceDataManager.getDateInYYYYMMDD() {
                dateChange = true
            }
        }
        
        if !SpaceDataManager.checkAllDataExists(type: .MarsArt, enity: ImageEnities.Met.rawValue) || dateChange {
            
            tempMarsArtData.removeAll()
            marsSearchOngoing = true
            if SpaceDataManager.checkAllDataExists(type: .MarsArt, enity: ImageEnities.Met.rawValue) {
                marsArtData = loadArtResponse(type: .MarsArt)
                loadMarsArt(objects: getRandomArtObjects(objects: marsObjects))
            } else {
                loadMarsArt(objects: getRandomArtObjects(objects: marsObjects)) 
            }
            
        } else {
           marsArtData = loadArtResponse(type: .MarsArt)
        }
    }
    
    func saveArtResponse(type: ImagePhotoType, data: [MetImageData])
    {
        guard let context = SpaceDataManager.managedContext else {
            return
        }
        SpaceDataManager.clearAllPhotoData(type: type, enity: ImageEnities.Met)
        let fetchDate = SpaceDataManager.getDateInYYYYMMDD()
        do {
            for image in data
            {
                let artImage = MetArtImage(context: context)
                artImage.type = type.rawValue
                artImage.url = image.url
                artImage.title = image.name
                artImage.id = Int32(image.id)
                artImage.fetchDate = fetchDate
                artImage.objDate = image.objectDate
                artImage.artistName = image.artistDisplayName
                artImage.objId = Int32(image.objectId)
                try context.save()
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            
        }
    }
    
    func loadArtResponse(type: ImagePhotoType)->[MetImageData]
    {
        var imageInfo = [MetImageData]()
        guard let context = SpaceDataManager.managedContext else {
            return imageInfo
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ImageEnities.Met.rawValue)
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        do {
            if let photos =  try context.fetch(fetchRequest) as? [MetArtImage] {
                for photo in photos
                {
                    guard let url = photo.url, let title = photo.title else {
                        return imageInfo
                    }
                    let info = MetImageData(objectId: Int(photo.objId), name: title, artistDisplayName: photo.artistName, objectDate: photo.objDate, objectName: nil, url: url, id: Int(photo.id), stringId: UUID().uuidString)
                    imageInfo.append(info)
                }
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return imageInfo
    }
    
    static func updateImage(image: UIImage, type: ImagePhotoType, id: Int)
    {
        artImages[type.rawValue + String(id)] = image
    }
    
    func saveToLibrary(image: MetImageData, type: ImagePhotoType)
    {
        
        serialQueue.async { [weak self] in
            guard let photo =  ArtDataManager.artImages[type.rawValue + String(image.id)]  else  {
                return // garantees it's downloaded
            }
            guard self?.libraryData.first(where: { $0.objectId == image.objectId}) == nil else {
                return // redundancy safetey check
            }
            guard let context = SpaceDataManager.managedContext else {
                return
            }
            
            let fetchDate = SpaceDataManager.getDateInYYYYMMDD()
            do {
                let artImage = MetArtImage(context: context)
                artImage.type = ImagePhotoType.Library.rawValue
                artImage.url = image.url
                artImage.title = image.name
                artImage.id = Int32(image.libraryKey)
                artImage.fetchDate = fetchDate
                artImage.objDate = image.objectDate
                artImage.artistName = image.artistDisplayName
                artImage.objId = Int32(image.objectId)
    #if os(macOS)

                artImage.image = photo.jpgData()
    #elseif os(iOS)
                artImage.image = photo.jpegData(compressionQuality: CGFloat(JPEGQuality.low.rawValue))
    #endif
                DispatchQueue.main.async { [weak self] in
                    self?.libraryData.append(image)
                }
                
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                
            }
        }
        
    }
    
    func deleteFromLibrary(image: MetImageData)
    {
        serialQueue.async {
            guard let context = SpaceDataManager.managedContext else {
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ImageEnities.Met.rawValue)
            fetchRequest.predicate = NSPredicate(format: "id == %d", image.libraryKey)
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
    }
}
