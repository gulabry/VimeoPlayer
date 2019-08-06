//
//  VideoTableViewCell.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 7/30/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import Foundation
import UIKit
import HCVimeoVideoExtractor
import AVFoundation

protocol VideoTableViewCellDelegate: AnyObject {
    func likeTapped(_ cell: VideoTableViewCell)
    func dislikeTapped(_ cell: VideoTableViewCell)
}

class VideoTableViewCell : UITableViewCell, ViewScalable {
    
    static let identifier = "videoCell"
    
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoSubtitleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    public weak var delegate: VideoTableViewCellDelegate?
    
    //  View Scalable Protocol View
    //
    var scaleView: UIView {
        return videoPlayerView
    }
    
    @IBAction func likeVideo(_ sender: UIButton) {
        delegate?.likeTapped(self)
    }
    
    @IBAction func dislikeVideo(_ sender: UIButton) {
        delegate?.dislikeTapped(self)
    }
    
    func play() {
        videoPlayerView.thumbnailImageView.isHidden = true
        videoPlayerView.player?.play()
    }
    
    func pause() {
        videoPlayerView.player?.pause()
        videoPlayerView.thumbnailImageView.isHidden = false
    }
    
    func setLiked() {
        likeButton.tintColor = #colorLiteral(red: 0.3294117647, green: 0.7058823529, blue: 0.5098039216, alpha: 1)
        dislikeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
    }
    
    func setDisliked() {
        dislikeButton.tintColor = #colorLiteral(red: 0.3294117647, green: 0.7058823529, blue: 0.5098039216, alpha: 1)
        likeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
    }
    
    override func prepareForReuse() {
        videoPlayerView.thumbnailImageView.image = nil
        videoPlayerView.player = nil
    }
    
    func setup(with video: Video) {
        
        selectionStyle = .none
        likeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
        dislikeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
        
        videoTitleLabel.text = video.name
        videoSubtitleLabel.text = video.description
        
        if VideoManager.shared.likedVideos.contains(video.link) {
            setLiked()
        }
        
        if VideoManager.shared.dislikedVideos.contains(video.link) {
            setDisliked()
        }
        
        if let image = VideoManager.shared.thumbnailImages[video.link] {
            videoPlayerView.thumbnailImageView.image = image
        }
    }
    
    func load(video: Video) {
        
        if let videoURL = video.streamURL {
            videoPlayerView.player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: videoURL)))
            return
        }
        
        video.getMetadata {
            
            if let thumbnailURL = video.thumbnailURL {
                VideoManager.downloadImage(from: thumbnailURL, completion: { image in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.videoPlayerView.thumbnailImageView.image = image
                    }
                    VideoManager.shared.addThumbnail(image: image, for: video.link)
                })
            }
            
            if let videoURL = video.streamURL {
                let playerItem = AVPlayerItem(asset: AVAsset(url: videoURL))
                DispatchQueue.main.async {
                    self.videoPlayerView.player = AVPlayer(playerItem: playerItem)
                }
            }
        }
    }
}
