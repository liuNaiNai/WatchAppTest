//
//  AnimationController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/29.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchKit

class AnimationController: WKInterfaceController {
    @IBOutlet weak var image: WKInterfaceImage!
    
    private let duration: TimeInterval = 1.25
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    @IBAction func planingAction() {
        animate(withDuration: duration) {
            self.image.setHorizontalAlignment(.right)
        }
        originalState()
    }
    @IBAction func zoomAction() {
        animate(withDuration: duration) {
            self.image.setWidth(100)
            self.image.setHeight(100)
        }
        originalState()
    }
    @IBAction func fadAction() {
        animate(withDuration: duration) {
            self.image.setAlpha(0.0)
        }
        originalState()
    }
    
    @IBAction func gifAction() {
        image.setImageNamed("Loading_")
        let range = NSRange(location: 1, length: 28)
        image.startAnimatingWithImages(in: range, duration: duration, repeatCount: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.image.setImageNamed("heart")
        }
    }
    private func originalState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.animate(withDuration: self.duration) {
                self.image.setHorizontalAlignment(.center)
                self.image.setWidth(50)
                self.image.setHeight(50)
                self.image.setAlpha(1.0)
            }
        }
    }
}
