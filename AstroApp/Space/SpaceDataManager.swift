//
//  SpaceDataManager.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/18/22.
//

import Foundation
import CoreData
class SpaceDataManager: ObservableObject
{
    @Published var imageOfDayData: [ImageInfo] = []
    @Published var curiosityPhotos: [ImageInfo] = []
    @Published var opportunityPhotos: [ImageInfo] = []
    @Published var spiritPhotos: [ImageInfo] = []
    var curiosityManifest: RoverManifest?
    var opportunityManifest: RoverManifest?
    var spiritManifest: RoverManifest?
    
    init()
    {
        
    }
    
    func fetchImageOfDay()->Void
    {
        imageOfDayData.removeAll()
        
        NasaFeed.getPhotoOfDay(completion: {[weak self] picture in
            let info: ImageInfo = ImageInfo(url: picture.url, description: picture.explanation, title: picture.title, id: self?.imageOfDayData.count ?? 0, mediaType: picture.media_type == MediaType.Video.rawValue ? .Video : .Picture)
            DispatchQueue.main.async { [weak self] in
                self?.imageOfDayData.append(info)
                let nasaType = NASAPhotoType.NasaPhotoOfDay
                if !(self?.checkAllDataExists(type: nasaType) ?? true) {
                    self?.saveNasaResponse(type: nasaType, data: [info])
                }
            }
        })
    }
    
    func parseManifest(manifest: String)->Void
    {
        DispatchQueue.global().async {
            let decoder = JSONDecoder()
            if let roverPath = Bundle(for: type(of: self)).url(forResource: manifest, withExtension: "json") {
                do {
                    let roverDataFileContent = try String(contentsOf: roverPath)
                    if let data = roverDataFileContent.data(using: .utf8) {
                        do {
                            let roverData = try decoder.decode(RoverManifest.self, from: data)
                            if manifest.hasPrefix("curiosity") {
                                self.curiosityManifest = roverData
                                self.fetchCuriosityPhotos()
                            } else if manifest.hasPrefix("opportunity") {
                                self.opportunityManifest = roverData
                                self.fetchOpportunityPhotos()
                            } else if manifest.hasPrefix("spirit") {
                                self.spiritManifest = roverData
                                self.fetchSpiritPhotos()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                catch {
                    print("failed to read file")
                }
            } else {
                print("no bundle url")
            }
        }
    }
    
    func fetchCuriosityPhotos()
    {
        
        if let list: [PhotoData] = curiosityManifest?.photo_manifest.photos.filter({ photo in
            // 2020 2021 2022 etc
            photo.total_photos > 4 && photo.earth_date.hasPrefix("202") &&  photo.cameras.first { $0 == "NAVCAM" } != nil
        }) {
            NasaFeed.getMarsPhotos(with: getMarsQuerry(from: list, with: "curiosity")) { [weak self] photoInfo in
                DispatchQueue.main.async { [weak self] in
                    self?.curiosityPhotos.removeAll()
                    if let mastPhoto = photoInfo.photos.first(where: { $0.camera.name == "NAVCAM" }) {
                        let info = ImageInfo(url: mastPhoto.img_src, description: mastPhoto.camera.full_name, title: mastPhoto.earth_date, id: self?.curiosityPhotos.count ?? 0, mediaType: .Picture)
                        self?.curiosityPhotos.append(info)
                        for photo in photoInfo.photos {
                            if photo.img_src == mastPhoto.img_src {
                                continue
                            }
                            let info = ImageInfo(url: photo.img_src, description: photo.camera.full_name, title: photo.earth_date, id: self?.curiosityPhotos.count ?? 0, mediaType: .Picture)
                            self?.curiosityPhotos.append(info)
                            let roverType = NASAPhotoType.Curiosity
                            if self?.curiosityPhotos.count ?? roverType.getMaxPhotos() >= roverType.getMaxPhotos() {
                                if !(self?.checkAllDataExists(type: roverType) ?? true) {
                                    if let curiosityPhotos = self?.curiosityPhotos {
                                        self?.saveNasaResponse(type: roverType, data: curiosityPhotos)
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func fetchOpportunityPhotos()
    {
        
        if let list: [PhotoData] = opportunityManifest?.photo_manifest.photos.filter({ photo in
            // 2020 2021 2022 etc
            photo.total_photos > 4 &&  photo.cameras.first { $0 == "NAVCAM" } != nil
        }) {
            NasaFeed.getMarsPhotos(with: getMarsQuerry(from: list, with: "opportunity")) { [weak self] photoInfo in
                DispatchQueue.main.async { [weak self] in
                    self?.opportunityPhotos.removeAll()
                    if let mastPhoto = photoInfo.photos.first(where: { $0.camera.name == "NAVCAM" }) {
                        let info = ImageInfo(url: mastPhoto.img_src, description: mastPhoto.camera.full_name, title: mastPhoto.earth_date, id: self?.opportunityPhotos.count ?? 0, mediaType: .Picture)
                        self?.opportunityPhotos.append(info)
                        for photo in photoInfo.photos {
                            if photo.img_src == mastPhoto.img_src {
                                continue
                            }
                            let info = ImageInfo(url: photo.img_src, description: photo.camera.full_name, title: photo.earth_date, id: self?.opportunityPhotos.count ?? 0, mediaType: .Picture)
                            self?.opportunityPhotos.append(info)
                            let roverType = NASAPhotoType.Opportunity
                            if self?.opportunityPhotos.count ?? roverType.getMaxPhotos() >= roverType.getMaxPhotos() {
                                if !(self?.checkAllDataExists(type: roverType) ?? true) {
                                    if let opportunityPhotos = self?.opportunityPhotos {
                                        self?.saveNasaResponse(type: roverType, data: opportunityPhotos)
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func fetchSpiritPhotos()
    {
        
        if let list: [PhotoData] = spiritManifest?.photo_manifest.photos.filter({ photo in
            // 2020 2021 2022 etc
            photo.total_photos > 4 &&  photo.cameras.first { $0 == "NAVCAM" } != nil
        }) {
            NasaFeed.getMarsPhotos(with: getMarsQuerry(from: list, with: "spirit")) { [weak self] photoInfo in
                DispatchQueue.main.async { [weak self] in
                    self?.spiritPhotos.removeAll()
                    if let mastPhoto = photoInfo.photos.first(where: { $0.camera.name == "NAVCAM" }) {
                        let info = ImageInfo(url: mastPhoto.img_src, description: mastPhoto.camera.full_name, title: mastPhoto.earth_date, id: self?.spiritPhotos.count ?? 0, mediaType: .Picture)
                        self?.spiritPhotos.append(info)
                        for photo in photoInfo.photos {
                            if photo.img_src == mastPhoto.img_src {
                                continue
                            }
                            let info = ImageInfo(url: photo.img_src, description: photo.camera.full_name, title: photo.earth_date, id: self?.spiritPhotos.count ?? 0, mediaType: .Picture)
                            self?.spiritPhotos.append(info)
                            let roverType = NASAPhotoType.Spirit
                            if self?.spiritPhotos.count ?? roverType.getMaxPhotos() >= roverType.getMaxPhotos() {
                                if !(self?.checkAllDataExists(type: roverType) ?? true) {
                                    if let spiritPhotos = self?.spiritPhotos {
                                        self?.saveNasaResponse(type: roverType, data: spiritPhotos)
                                    }
                                }
                                break
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func getMarsQuerry(from list: [PhotoData], with rover: String)->String
    {
        let max = list.count
        let choice = Int(arc4random_uniform(UInt32(max)))
        let solDay = String(list[choice].sol)
        let querry =  "https://api.nasa.gov/mars-photos/api/v1/rovers/" + rover + "/photos?sol=" + solDay + "&api_key="
        return querry
    }
}
