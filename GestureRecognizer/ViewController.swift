//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Daymein Gregorio on 2017/09/25.
//  Copyright © 2017 Daymein Gregorio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appIcon: UIView!
    @IBOutlet weak var trash:   UIView!
    
    private var appOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appOrigin = appIcon.frame.origin
        addPanGestureRecognizerTo(subView: appIcon)
    }
    
    private func addPanGestureRecognizerTo(subView: UIView) {
        let panGestRec = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        subView.isUserInteractionEnabled = true
        subView.addGestureRecognizer(panGestRec)
    }
    
    @objc internal func handleDrag(_ sender: UIPanGestureRecognizer) {
        view.bringSubview(toFront: appIcon)
        let state = sender.state
        
        switch state {
        case .began, .changed:
            let translation = sender.translation(in: view)
            appIcon.center = CGPoint(x: appIcon.center.x + translation.x,
                                     y: appIcon.center.y + translation.y)
            sender.setTranslation(.zero, in: view)
        case .ended:
            if appIcon.frame.intersects(trash.frame) {
                disposeOfApp()
            } else {
                resetIconPosition()
            }
        default:
            break
        }
    }
    
    private func resetIconPosition() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.appIcon.frame.origin = self.appOrigin
        }
    }
    
    private func disposeOfApp() {
        UIView.animate(withDuration: 0.18) { [unowned self] in
            self.appIcon.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.appIcon.center = self.trash.center
            self.appIcon.alpha = 0
        }
    }
    
    @IBAction func reset() {
        appIcon.transform = CGAffineTransform.identity
        appIcon.frame.origin = appOrigin
        appIcon.alpha = 1
    }

}

