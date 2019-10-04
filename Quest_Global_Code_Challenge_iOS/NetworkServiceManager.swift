//
//  NetworkServiceManager.swift
//  Quest_Global_Code_Challenge_iOS
//
//  Created by Erick Quintanar on 10/2/19.
//  Copyright © 2019 Erick Quintanar. All rights reserved.
//

import Foundation

enum NetworkingError : Error {
    case requestCreation
    case xmlParsing
    case noInternet
    case noSuccessStatusCode
    case other
}

typealias JSONDataResult = (_ error: Error?, _ data: VideoDataCodable) -> Void

class NetworkServiceManager {
    
    static let shared = NetworkServiceManager()
    private let session: URLSession
    
    private init () {
        session = URLSession.shared
    }
    
    func getPopularVideoData(completion: @escaping JSONDataResult) {
        
        print("getPopularVideoData - NetworkServiceManager Stuff")
        
//        let urlString = "https://api.pexels.com/videos/popular?per_page5&page=1"
        let urlString = "https://api.pexels.com/videos/search?query=cats&per_page=5&page=1"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.addValue("563492ad6f9170000100000132237431be6246d7ba3a4b2ca870edf1", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil{
                print("error")
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                decoder.keyDecodingStrategy = .useDefaultKeys
                
                let videoData = try decoder.decode(VideoDataCodable.self, from: data)
                completion(nil, videoData)
                
            } catch let err {
                print("Err", err)
            }
        }
        task.resume()
        
    }
    
    
}
