//
//  Video.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 7/30/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import Foundation

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

struct Video: Codable {
    var name: String
    var description: String?
    var link: String
    var duration: Int
}
