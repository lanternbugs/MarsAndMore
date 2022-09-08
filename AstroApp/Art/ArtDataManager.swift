//
//  ArtDataManager.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/11/22.
//

import Foundation
import Combine
#if os(iOS)
    import UIKit
#endif
    class ArtDataManager: ObservableObject
{
    @Published var venusArtData = [MetImageData]()
    @Published var marsArtData = [MetImageData]()
    @Published var libraryData = [MetImageData]()
    let serialQueue = DispatchQueue(label: "coreDataSerialQueue")
    static var artImages = Dictionary<String, UIImage>()
    var tempVenusArtData = [MetImageData]()
    var tempMarsArtData = [MetImageData]()
    var cancellables = Set<AnyCancellable>()
    let maxRequests = 8
    var venusSearchOngoing = false
    var marsSearchOngoing = false
    static let libraryOffset = 100000
    
    let venusObjects = [38141, 736558, 811890, 207593, 435826, 437891, 436322, 438127, 13202, 437310, 447802, 188325, 198134, 692509, 717152, 360094, 369550, 845724, 437314, 55392, 407365, 737925, 811971, 819742, 739361, 742689, 54010, 396879, 813293, 819448, 394745, 437227, 720282, 342902, 823883, 774799, 693138, 436330, 633712, 820845, 787982, 468064, 834082, 390795, 787969, 774746, 211462, 392799, 392655, 392648, 391536, 392802, 392650, 816515, 392666, 392661, 392665, 392667, 392653, 392657, 392654, 392668, 392831, 392836, 392805, 397867, 397870, 397865, 425363, 397872, 334653, 57035, 344913, 452805, 648576, 78671, 742878, 11157, 854846, 334654, 459427, 692480, 369384, 369293, 557674, 362018, 557804, 666318, 336278, 340847, 667858, 11207, 55371, 36921, 56815, 336353, 742765, 392625, 717183, 78664, 737578, 254646, 437532, 37942, 13143, 436918, 849466, 204804, 437535, 246657, 437987, 229933, 810877, 36616, 401151, 361833, 37140, 435743, 631209, 811251, 811252, 37872, 437059, 282043, 337690, 820057, 193702, 254502, 17066, 11712, 436056, 438158, 188827, 226696, 436037, 45009, 473331, 337500, 10240, 12651, 12699, 191292, 437525, 65594, 436945, 436041, 435762, 397527, 436069, 436896, 437878, 715062, 711826, 37962, 459038, 459037, 10785, 13057, 459060, 437346, 438126, 436906, 435738, 436042, 436453, 435844, 437339, 634108, 436325, 436910, 437393, 436150, 437069, 437880, 437177, 436904, 437827, 437749, 435772, 437398, 747607, 437476, 436930, 436988, 437826, 435747, 459065, 437955, 436903, 436570, 436511, 436905, 436582, 436866, 10967, 37992, 13198, 437944, 438110, 438821, 438815, 665702, 437638, 436838, 435714, 459077, 436201, 453283, 685040, 438726, 670765, 437754, 437523, 437218, 437496, 828241, 435691, 436121, 437936, 440729, 436616, 436579, 436106, 436213, 437439, 435745, 435594, 437425, 437437, 436703, 435718, 437480, 437153, 847023, 436937, 437859, 438098, 436543, 438887, 436819, 436162, 436547, 436548, 336043, 339817, 337864]
    let marsObjects = [437891, 11867, 12667, 10431, 436252, 13346, 10968, 74726, 11133, 10527, 12822, 437868, 11134, 11160, 437052, 437536, 51595, 438541, 436107, 437220, 437219, 436188, 437192, 10819, 767842, 436691, 437861, 436007, 437660, 436554, 438118, 437826, 10449, 437262, 10448, 13345, 437327, 435868, 10554, 13198, 437283, 436794, 437890, 437284, 436843, 436948, 11140, 12672, 438129, 11243, 437990, 11301, 437260, 437344, 437505, 435778, 437496, 437171, 436105, 435665, 437487, 437416, 380381, 343066, 350683, 371557, 357222, 338666, 337587, 336016, 336438, 339776, 338731, 337777, 337079, 339829, 337861, 337924, 335581, 337675, 339746, 339657, 339821, 340743, 488103, 10079, 363486, 334634, 348229, 318361, 335984, 766781, 766445, 766443, 679911, 336573, 751521, 348230, 339261, 359062, 428620, 430867, 365663, 812270, 334210, 459497, 676968, 335829, 13382, 382747, 57256, 642818, 771456, 841545, 363024, 343316, 382523, 355665, 704472, 337191, 347506, 382875, 395686, 704468, 13541, 339824, 3538]
    // 2606
    let segment = 1
    let imageTypePainting = false
    // love search
    
    init() {
       // print("venus count is \(venusObjects.count) and Mars count is \(marsObjects.count)")
        //loadSelectArt(from: selectArt)
       // checkForDuplicates(marsObjects, with: "mars")
       // checkForDuplicates(venusObjects, with: "venus")
    }
    func checkForDuplicates(_ objects: [Int], with type: String)
    {
        var masterSet = Set<Int>()
        for val in objects {
            if masterSet.contains(val) {
                print("duplicate found: \(val) of type \(type)")
            } else {
                masterSet.insert(val)
            }
        }
    }
    func getRandomArtObjects(objects: [Int])->[Int]
    {
        var curratedObjects = [Int]()
        var mutatedObjects = objects
        for _ in 1...maxRequests {
            guard mutatedObjects.count > 0 else {
                continue
            }
            let randomInt = Int.random(in: 0..<mutatedObjects.count)
            curratedObjects.append(mutatedObjects[randomInt])
            mutatedObjects.remove(at: randomInt)
        }
        return curratedObjects
    }
    
    func loadVenusArt(objects: [Int])
    {
        for object in objects {
            guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + String(object)) else {
                continue
            }
            self.getArt(with: url).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in }, receiveValue: { [weak self] data in
                if let stringURL = data.primaryImage, let name = data.title, let url = URL(string: stringURL), let publicImage = data.isPublicDomain, publicImage {
                    self?.tempVenusArtData.append(MetImageData(objectId: data.objectID, name: name, artistDisplayName: data.artistDisplayName, objectDate: data.objectDate, objectName: data.objectName, url: url, id: self?.tempVenusArtData.count ?? 0, stringId: UUID().uuidString))
                    if self?.tempVenusArtData.count ?? 0 == ImagePhotoType.VenusArt.getMaxPhotos() {
                        if let tempData = self?.tempVenusArtData {
                            self?.venusArtData = tempData
                            self?.saveArtResponse(type: .VenusArt, data: tempData)
                            self?.venusSearchOngoing = false
                        }
                    }
                }
            }).store(in: &self.cancellables)
       
        }
    }
    
    func loadMarsArt(objects: [Int])
    {
        for object in objects {
            guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + String(object)) else {
                continue
            }
            self.getArt(with: url).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in }, receiveValue: { [weak self] data in
                if let stringURL = data.primaryImage, let name = data.title, let url = URL(string: stringURL), let publicImage = data.isPublicDomain, publicImage {
                    self?.tempMarsArtData.append(MetImageData(objectId: data.objectID, name: name, artistDisplayName: data.artistDisplayName, objectDate: data.objectDate, objectName: data.objectName, url: url, id: self?.tempMarsArtData.count ?? 0, stringId: UUID().uuidString))
                    if self?.tempMarsArtData.count ?? 0 == ImagePhotoType.MarsArt.getMaxPhotos() {
                        if let tempData = self?.tempMarsArtData {
                            self?.marsArtData = tempData
                            self?.saveArtResponse(type: .MarsArt, data: tempData)
                            self?.marsSearchOngoing = false
                        }
                    }
                }
            }).store(in: &self.cancellables)
       
        }
    }
    
    func loadSelectArt(from objects: [Int])
      {
          let min = segment * 50
          var max = min + 50
          if max > objects.count  {
              max = objects.count
          }
          if min >= objects.count {
              return;
          }
          for i in min..<max {
              guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + String(objects[i])) else {
                  continue
              }
              self.getArt(with: url).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in }, receiveValue: { [weak self] data in
                  if let stringURL = data.primaryImage, let name = data.title, let url = URL(string: stringURL) {
                      if let publicImage = data.isPublicDomain, publicImage {
                          if let self = self, self.imageTypePainting {
                              if data.objectName == "Painting" {
                                  self.marsArtData.append(MetImageData(objectId: data.objectID, name: name, artistDisplayName: data.artistDisplayName, objectDate: data.objectDate, objectName: data.objectName, url: url, id: self.marsArtData.count, stringId: UUID().uuidString))
                              } else {
                                  print("not a Painting")
                              }
                          } else {
                              self?.marsArtData.append(MetImageData(objectId: data.objectID, name: name, artistDisplayName: data.artistDisplayName, objectDate: data.objectDate, objectName: data.objectName, url: url, id: self?.marsArtData.count ?? 0, stringId: UUID().uuidString))
                          }
                          
                      } else {
                          print("object \(data.objectID) is not public domain")
                      }
                      
                  }
              }).store(in: &self.cancellables)
          }
      }
    
    
    func getArt(with url: URL) -> AnyPublisher<MetImage, Error> {
            
        return URLSession.shared.dataTaskPublisher(for: url).map { $0.data }
        .decode(type: MetImage.self, decoder: JSONDecoder())
        .mapError({[weak self] error in
                switch error {
                case is Swift.DecodingError:
                    print(error)
                  return FailureReason.decodingFailed
                case let urlError as URLError:
                    self?.venusSearchOngoing = false
                    self?.marsSearchOngoing = false
                  return FailureReason.sessionFailed(error: urlError)
                default:
                  return FailureReason.other(error)
                }
              })
        .eraseToAnyPublisher()
            
    }
}
