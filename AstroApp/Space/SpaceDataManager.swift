//
//  SpaceDataManager.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/18/22.
//

import Foundation
class SpaceDataManager: ObservableObject
{
    @Published var imageOfDayData: [ImageInfo] = []
    @Published var marsRoverData: [ImageInfo] = []
    @Published var curiosityPhotos: [ImageInfo] = []
    var curiosityManifest: RoverManifest?
    
    init()
    {
        fetchData()
        parseManifest(manifest: "curiosity-manifest")
    }
    
    func fetchData()->Void
    {
        imageOfDayData.removeAll()
        marsRoverData.removeAll()
        
        NasaFeed.getPhotoOfDay(completion: {[weak self] picture in
            let info: ImageInfo = ImageInfo(url: picture.url, description: picture.explanation, title: picture.title, id: self?.imageOfDayData.count ?? 0)
            DispatchQueue.main.async { [weak self] in
                self?.imageOfDayData.append(info)
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
                            } else if manifest.hasPrefix("curiosity") {
                                
                            } else {
                                
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
                    if let mastPhoto = photoInfo.photos.first(where: { $0.camera.name == "NAVCAM" }) {
                        let info = ImageInfo(url: mastPhoto.img_src, description: mastPhoto.camera.full_name, title: mastPhoto.earth_date, id: self?.curiosityPhotos.count ?? 0)
                        self?.curiosityPhotos.append(info)
                        for photo in photoInfo.photos {
                            if photo.img_src == mastPhoto.img_src {
                                continue
                            }
                            let info = ImageInfo(url: photo.img_src, description: photo.camera.full_name, title: photo.earth_date, id: self?.curiosityPhotos.count ?? 0)
                            self?.curiosityPhotos.append(info)
                            if self?.curiosityPhotos.count ?? 5 > 4 {
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
        return "https://api.nasa.gov/mars-photos/api/v1/rovers/" + rover + "/photos?sol=" + solDay + "&api_key="
    }
}
