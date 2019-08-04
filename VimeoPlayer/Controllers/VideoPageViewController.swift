//
//  VideoPageViewController.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 8/3/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import UIKit
import AVKit

class VideoPageViewController: UIViewController {
    
    var videoControllers: [AVPlayerViewController]!
    var startingVideo: Video!
    
    @IBOutlet weak var pageVCHolderView: UIView!
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pausePlayButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoControllers =  VideoManager.shared.videos.map { createPlayer(for: $0) }

        if let pageController = children.first as? UIPageViewController {
            pageViewController = pageController
            pageViewController.delegate = self
            pageViewController.dataSource = self
            
            guard let startingVideoIndex = VideoManager.shared.videos.firstIndex(of: startingVideo) else { return }
            let startingVideoPlayer = videoControllers[startingVideoIndex]
            
            pageViewController.setViewControllers([startingVideoPlayer], direction: .forward, animated: true, completion: nil)
            startingVideoPlayer.player?.play()
        }
    }
    
    @IBAction func exitVideoPlayer(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func muteVideos(_ sender: UIButton) {
        let vc = pageViewController.viewControllers?.last as! AVPlayerViewController
        if vc.player?.volume == 0.0 {
            vc.player?.volume = 1.0
            muteButton.tintColor = UIColor.white
        } else {
            vc.player?.volume = 0.0
            muteButton.tintColor = #colorLiteral(red: 0.7935120463, green: 0.0137836216, blue: 0.001650006394, alpha: 1)
        }
    }
    
    @IBAction func playPauseVideo(_ sender: UIButton) {
        let vc = pageViewController.viewControllers?.last as! AVPlayerViewController
        
        if vc.player?.rate == 0.0 {
            vc.player?.play()
            pausePlayButton.setImage(UIImage(named: "pause")!, for: .normal)
        } else {
            vc.player?.pause()
            pausePlayButton.setImage(UIImage(named: "play")!, for: .normal)
        }
    }
    
    func createPlayer(for video: Video) -> AVPlayerViewController {
        
        let vc = AVPlayerViewController()
        guard let streamURL = video.streamURL else { return vc }
        vc.player = AVPlayer(url: streamURL)
        vc.showsPlaybackControls = false
        return vc
    }
}

extension VideoPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = videoControllers.firstIndex(of: viewController as! AVPlayerViewController),
            index > 0 {
            return videoControllers[index - 1]
        }

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let index = videoControllers.firstIndex(of: viewController as! AVPlayerViewController),
            index < videoControllers.count - 1 {
            return videoControllers[index + 1]
        }
        
        return nil
    }
}

extension VideoPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        for vc in pendingViewControllers {
            let vc = vc as! AVPlayerViewController
            vc.player?.play()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
//        for vc in previousViewControllers {
//            let vc = vc as! AVPlayerViewController
//            vc.player?.pause()
//        }
//
        if completed {
            for vc in previousViewControllers {
                let vc = vc as! AVPlayerViewController
                vc.player?.pause()
            }
//            let vc = previousViewControllers.last as! AVPlayerViewController
//            vc.player?.play()
        }
    }
}
