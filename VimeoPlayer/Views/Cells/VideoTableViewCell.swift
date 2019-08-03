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
    
    func setup(with video: Video) {
        likeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
        dislikeButton.tintColor = #colorLiteral(red: 0.07057534903, green: 0.07059565932, blue: 0.07057406753, alpha: 1)
        
        videoPlayerView.thumbnailImageView.image = nil
        videoPlayerView.player = nil
        
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
        
        if let videoURL = VideoManager.shared.downloadedVideos[video.link] {
            videoPlayerView.player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: videoURL)))
        } else {
            load(video: video)
        }
    }
    
    func load(video: Video) {
        
        guard let videoURL = URL(string: video.link) else { return }
        
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: videoURL, completion: { videoFile, error in

            if let thumbnailURL = (videoFile?.thumbnailURL.values.compactMap { $0 }.last) {
                
                VideoManager.downloadImage(from: thumbnailURL, completion: { image in
                    guard let image = image else { return }
                    self.videoPlayerView.thumbnailImageView.image = image
                    VideoManager.shared.addThumbnail(image: image, for: video.link)
                })
            }
            
            //  streaming the lowest quality video for bandwidth purposes
            //
            if let videoURL = (videoFile?.videoURL.values.compactMap { $0 }.first) {
                DispatchQueue.main.async {
                    let playerItem = AVPlayerItem(asset: AVAsset(url: videoURL))
                    self.videoPlayerView.player = AVPlayer(playerItem: playerItem)
                    VideoManager.shared.add(videoURL: videoURL, for: video.link)
                }
            }
        })
    }
}
