//
//  ArtDataManager.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/11/22.
//

import Foundation
import Combine

class ArtDataManager: ObservableObject
{
    @Published var artData = [MetImageData]()
    var cancellables = Set<AnyCancellable>()
    // hard coded objects for now in one place. will be making currated lists to choose art of day
    let objects = [281940,38141,488319,435826,736558,811890,693667,475487,437891,207593,436322,490222,499568,112900,438127,13060,889329,746246,194458,124263,499032,103288,103286,103289,103287,103290,94556,158848,106028,841605,102923,102924,103284,103292,103291,104957,13202,464125,437310,1894,7595,476552,207665,468732,267,468737,477221,489721,4897,4896]
    
    init() {
        for object in objects {
            guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + String(object)) else {
                continue
            }
            self.getArt(with: url).receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in }, receiveValue: { [weak self] data in
                if let stringURL = data.primaryImage, let name = data.title, let url = URL(string: stringURL) {
                    self?.artData.append(MetImageData(objectId: data.objectID, name: name, url: url, id: self?.artData.count ?? 0))
                }
            }).store(in: &self.cancellables)
       
        }
        
    }
    
    func getArt(with url: URL) -> AnyPublisher<MetImage, Error> {
            
        return URLSession.shared.dataTaskPublisher(for: url).map { $0.data }
        .decode(type: MetImage.self, decoder: JSONDecoder())
        .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    print(error)
                  return FailureReason.decodingFailed
                case let urlError as URLError:
                  return FailureReason.sessionFailed(error: urlError)
                default:
                  return FailureReason.other(error)
                }
              })
        .eraseToAnyPublisher()
            
    }
}
