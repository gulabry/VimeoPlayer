//
//  ViewController.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 7/30/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import UIKit
import AVKit
import HCVimeoVideoExtractor

class VideoSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videoManager = VideoManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        VimeoAPI.fetchVideos(from: VimeoAPI.comedyVideoURL) { videos in
            
            guard videos.count > 0 else { return }
            
            self.videoManager.set(videos: videos)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension VideoSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoManager.numberOfVideos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
        cell.delegate = self
        
        let video = videoManager.videoAt(index: indexPath.row)
        
        cell.setup(with: video)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let tableView = scrollView as? UITableView else { return }
        
        for cell in tableView.visibleCells {
            
            guard let cell = cell as? VideoTableViewCell,
                let indexPath = tableView.indexPath(for: cell) else { return }
            
            let cellRect = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
            
            if cellRect.minY > -1 && cellRect.minY < cellRect.height {
                cell.play()
            } else {
                cell.pause()
            }
        }
    }
}

extension VideoSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension VideoSelectionViewController: VideoTableViewCellDelegate {
    func likeTapped(_ cell: VideoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        cell.setLiked()
        videoManager.like(at: indexPath.row)
    }
    
    func dislikeTapped(_ cell: VideoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        cell.setDisliked()
        videoManager.dislike(at: indexPath.row)
    }
}
