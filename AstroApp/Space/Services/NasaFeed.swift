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
struct NasaFeed
{
    static let urlSession = URLSession(configuration: .default)
    static func getPhotoOfDay(completion: @escaping (PictureOfDay?)->Void)
    {
        
        var dataTask: URLSessionDataTask?
        let urlWithApiKey = "https://api.nasa.gov/planetary/apod?api_key=" + getApiKey()
        guard let url = URL(string: urlWithApiKey) else {
            return
        }
        dataTask = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
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
                        completion(nil)
                    }
                    
                    
                }
                else {
                    if let response = response as? HTTPURLResponse {
                        print("Response \(response.statusCode)")
                        completion(nil)
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    static func getMarsPhotos(with querry: String, completion: @escaping (RoverPhotos)->Void)
    {
        
        var dataTask: URLSessionDataTask?
        let urlWithApiKey = querry + getApiKey()
        guard let url = URL(string: urlWithApiKey) else {
            return
        }
        dataTask = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(RoverPhotos(photos: []))
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
                      let photoInfo = try decoder.decode(RoverPhotos.self, from: data)
                        completion(photoInfo)
                    } catch
                    {
                        print(error)
                        completion(RoverPhotos(photos: []))
                    }
                    
                    
                }
                else {
                    if let response = response as? HTTPURLResponse {
                        print("Response \(response.statusCode)")
                        completion(RoverPhotos(photos: []))
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
