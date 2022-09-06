//
//  ArtDataManager+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/17/22.
//

import Foundation
import CoreData
extension ArtDataManager {
    static var managedContext: NSManagedObjectContext?
    
    func setContextAndLoad(_ context: NSManagedObjectContext) {
        ArtDataManager.managedContext = context
        //SpaceDataManager.clearAllPhotoData(type: .VenusArt, enity: ImageEnities.Met)
        //SpaceDataManager.clearAllPhotoData(type: .MarsArt, enity: ImageEnities.Met)
        loadVenusArt()
        loadMarsArt()
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
            print("Could not fetch \(error), \(error.userInfo)")
            
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
}