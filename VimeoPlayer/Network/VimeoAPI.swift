//
//  VimeoAPI.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 7/30/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import Foundation

struct Credentials {
    static let apiKey = "bearer 5b955cda1b0e5f8b7e3afefa6863886c"
}

struct VimeoAPI {
    
    static let baseURL = URL(string: "https://api.vimeo.com/")!
    static let comedyVideoURL = baseURL.appendingPathComponent("categories/comedy/videos")
    
    static func fetchVideos(from url: URL, completion: @escaping ([Video]) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Credentials.apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return completion([Video]())}
            
            do {
                
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                completion(videoResponse.data)
                
            } catch let err {
                print(err.localizedDescription)
                completion([Video]())
            }
            
        }.resume()
    }
}
