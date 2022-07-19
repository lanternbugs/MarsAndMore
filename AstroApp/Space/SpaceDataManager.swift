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
    
    init()
    {
        fetchData()
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
}
