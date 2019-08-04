//
//  ScaleSegue.swift
//  VimeoPlayer
//
//  Created by Bryan Gula on 8/3/19.
//  Copyright © 2019 Bryan Gula. All rights reserved.
//

import UIKit

protocol ViewScalable: UIView {
    var scaleView: UIView { get }
}

class ScaleSegue: UIStoryboardSegue {
    
    static let identifier = "scaleSegue"
    
    override func perform() {
        destination.transitioningDelegate = self
        super.perform()
    }
    
}

extension ScaleSegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScalePresentAnimator()
    }
}

class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? VideoSelectionViewController,
            let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let toView = transitionContext.view(forKey: .to)
        
        if let toView = transitionContext.view(forKey: .to) {
            transitionContext.containerView.addSubview(toView)
        }
        
        guard let indexPath = fromViewController.tableView.indexPathForSelectedRow else { return }
        
        var startFrame: CGRect = .zero
        if let selectedCell = fromViewController.tableView.cellForRow(at: indexPath),
            let scalableView = selectedCell as? ViewScalable,
            let selectedCellSuperview = selectedCell.superview {

            startFrame = selectedCellSuperview.convert(scalableView.frame, to: nil)
        }
        
        toView?.frame = startFrame
        toView?.layoutIfNeeded()
        
        let duration = transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        UIView.animate(withDuration: duration, animations: {
            toView?.frame = finalFrame
            toView?.layoutIfNeeded()
        }) { finished in
            transitionContext.completeTransition(true)
        }
    }
}
