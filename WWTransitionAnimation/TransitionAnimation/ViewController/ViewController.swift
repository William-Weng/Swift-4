//
//  ViewController.swift
//  TransitionAnimation
//
//  Created by William-Weng on 2018/07/07.
//  Copyright © 2017年 William-Weng. All rights reserved.
//
/// [Swift 自訂義非交互轉場動畫（Custom Transition Animation）](https://ios.devdon.com/archives/358)

import UIKit

class ViewController: UIViewController {
    
    var otherImageView: UIImageView!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))

        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(tapGestureRecognizer)
        
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func imageTapped(_ tap: UITapGestureRecognizer) {
        guard let _ = tap.view as? UIImageView else { return }
        
        otherImageView = UIImageView.init(image: #imageLiteral(resourceName: "jewelry"))
        otherImageView.frame = myImageView.frame
        view.addSubview(otherImageView)
        
        gotoNextPage()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        print("unwindSegue")
    }
}

// MARK: UINavigationControllerDelegate ==> ❶Navigation
extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = SimpleTransition()
        
        print("operation = \(operation.rawValue), \(operation)")
        return transition
    }
}

// MARK: UITabBarControllerDelegate ==> ❷TabBar
extension ViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SimpleTransition()
        return transition
    }
}

// MARK: UIViewControllerTransitioningDelegate ==> ❸Modal
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = SimpleTransition()
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SimpleTransition()
        return transition
    }
}

extension ViewController {
    
    /// 到下一頁
    private func gotoNextPage() {
        
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let detailViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController")
        
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.transitioningDelegate = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

class SimpleTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    static var originInfo: (frame: CGRect, backgroundColor: UIColor?) = (CGRect.zero, nil)

    // 定義轉場動畫為0.8秒
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0.8 }
    
    // 具體的轉場動畫
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let fromView = fromVC?.view
        let toView = toVC?.view
        
        if let fromVC = fromVC as? ViewController {
            SimpleTransition.originInfo.frame = fromVC.otherImageView.frame
            SimpleTransition.originInfo.backgroundColor = fromVC.view.backgroundColor
        }
        
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        toView?.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            
            if let fromVC = fromVC as? ViewController, let toVC = toVC as? DetailViewController {
                fromVC.otherImageView.frame = toVC.myImageView.frame
                fromVC.view.backgroundColor = toVC.view.backgroundColor
                return
            }
            
            if let fromVC = fromVC as? DetailViewController {
                fromVC.myImageView.frame = SimpleTransition.originInfo.frame
                fromVC.view.backgroundColor = SimpleTransition.originInfo.backgroundColor
                return
            }
            
        }, completion: { finished in
            
            toView?.alpha = 1.0
            
            if let fromVC = fromVC as? ViewController {
                fromVC.otherImageView.removeFromSuperview()
                fromVC.view.backgroundColor = SimpleTransition.originInfo.backgroundColor
            }
            
            transitionContext.completeTransition(true) // 通知完成轉場
        })
    }
}
