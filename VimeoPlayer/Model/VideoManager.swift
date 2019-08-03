//
//  VideoManager.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 8/1/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import HCVimeoVideoExtractor

struct Constants {
    static let likedVideoKey = "likedVideoKey"
    static let dislikedVideoKey = "dislikedVideoKey"
}

class VideoManager {
    
    static let shared = VideoManager()
    
    var videos: [Video]!
    
    var thumbnailImages = [String: UIImage]()
    var downloadedVideos = [String:URL]()
    
    var likedVideos = [String]()
    
    var dislikedVideos = [String]()
    
    init(with videos: [Video]) {
        self.videos = videos
        commonInit()
    }
    
    init() {
        self.videos = [Video]()
        commonInit()
    }
    
    func commonInit() {
        if let likedArray = UserDefaults.standard.value(forKey: Constants.likedVideoKey) as? [String] {
            likedVideos = likedArray
        }
        
        if let dislikedArray = UserDefaults.standard.value(forKey: Constants.dislikedVideoKey) as? [String] {
            dislikedVideos = dislikedArray
        }
    }
    
    func videoAt(index: Int) -> Video {
        return videos[index]
    }
    
    func numberOfVideos() -> Int {
        return videos.count
    }
    
    func set(videos: [Video]) {
        self.videos = videos
    }
    
    func addThumbnail(image: UIImage, for link: String) {
        thumbnailImages[link] = image
    }
    
    func add(videoURL: URL, for videoLink: String) {
        downloadedVideos[videoLink] = videoURL
    }
    
    func like(at index: Int) {
        let link = videos[index].link
        if dislikedVideos.contains(link) {
            dislikedVideos = dislikedVideos.filter { $0 != link }
        }
        likedVideos.append(link)
        UserDefaults.standard.set(likedVideos, forKey: Constants.likedVideoKey)
    }
    
    func dislike(at index: Int) {
        let link = videos[index].link
        if likedVideos.contains(link) {
            likedVideos = likedVideos.filter { $0 != link }
        }
        dislikedVideos.append(link)
        UserDefaults.standard.set(dislikedVideos, forKey: Constants.dislikedVideoKey)
    }
    
    static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        getThumbnailData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
    }
    
    static private func getThumbnailData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
