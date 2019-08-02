//
//  VideoTableViewCell.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 7/30/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import Foundation
import UIKit

protocol VideoTableViewCellDelegate: AnyObject {
    func likeTapped(_ cell: VideoTableViewCell)
    func dislikeTapped(_ cell: VideoTableViewCell)
}

class VideoTableViewCell : UITableViewCell {
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoSubtitleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    public weak var delegate: VideoTableViewCellDelegate?
    
    @IBAction func likeVideo(_ sender: UIButton) {
        delegate?.likeTapped(self)
    }
    
    @IBAction func dislikeVideo(_ sender: UIButton) {
        delegate?.dislikeTapped(self)
    }
    
    func setLiked() {
        likeButton.tintColor = #colorLiteral(red: 0.3294117647, green: 0.7058823529, blue: 0.5098039216, alpha: 1)
        dislikeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
    }
    
    func setDisliked() {
        dislikeButton.tintColor = #colorLiteral(red: 0.3294117647, green: 0.7058823529, blue: 0.5098039216, alpha: 1)
        likeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
    }
    
    func setup(with video: Video) {
        likeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
        dislikeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
        
        videoPlayerView.thumbnailImageView.image = nil
        videoPlayerView.player = nil
        
        videoTitleLabel.text = video.name
        videoSubtitleLabel.text = video.description
    }
}
