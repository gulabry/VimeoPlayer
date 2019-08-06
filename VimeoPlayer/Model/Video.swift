//
//  Video.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 7/30/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import Foundation
import HCVimeoVideoExtractor

struct VideoResponse: Codable {
    var page: Int
    var per_page: Int
    var paging: Paging
    var data: [Video]
}

struct Paging: Codable {
    var next: String?
    var previous: String?
    var first: String
    var last: String
}

class Video: Codable, Equatable {
    
    var name: String
    var description: String?
    var link: String
    var duration: Int
    
    var thumbnailURL: URL?
    var streamURL: URL?
    
    func getMetadata(completion: @escaping () -> ()) {
        
        guard let videoURL = URL(string: link) else { return }
        
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: videoURL, completion: { videoFile, error in
            
            if let thumbnailURL = (videoFile?.thumbnailURL.values.compactMap { $0 }.first) {
                self.thumbnailURL = thumbnailURL
            }
            
            if let videoURL = (videoFile?.videoURL.values.compactMap { $0 }.last) {
                self.streamURL = videoURL
            }
            
            completion()
        })
    }
    
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.name == rhs.name &&
            lhs.description == rhs.description &&
            lhs.link == rhs.link &&
            lhs.duration == rhs.duration
    }
}


