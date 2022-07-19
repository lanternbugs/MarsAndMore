//
//  AurorasLiveFeedAPI.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/16/22.
//

import Foundation
struct NasaFeed
{
    static let urlSession = URLSession(configuration: .default)
    static func getPhotoOfDay(completion: @escaping (PictureOfDay)->Void)
    {
        
        var dataTask: URLSessionDataTask?
        let urlWithApiKey = "https://api.nasa.gov/planetary/apod?api_key=" + getApiKey()
        guard let url = URL(string: urlWithApiKey) else {
            return
        }
        dataTask = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else
            {
                if let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        guard let data = data else {
                            print("data invalid")
                            return
                        }
                      let photoInfo = try decoder.decode(PictureOfDay.self, from: data)
                        completion(photoInfo)
                    } catch
                    {
                        print(error)
                    }
                    
                    
                }
                else {
                    if let response = response as? HTTPURLResponse {
                        print("Response \(response.statusCode)")
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    static func getApiKey()->String
    {
        // get your own api key https://api.nasa.gov/
        return "DEMO_KEY"
    }
}
