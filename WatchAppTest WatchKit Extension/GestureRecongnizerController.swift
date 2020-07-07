//
//  GestureRecongnizerController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/28.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchKit

class GestureRecongnizerController: WKInterfaceController {

    @IBOutlet weak var tapLab: WKInterfaceLabel!
    @IBOutlet weak var longLab: WKInterfaceLabel!
    @IBOutlet weak var panLab: WKInterfaceLabel!
    @IBOutlet weak var swipeLab: WKInterfaceLabel!
    
    @IBAction func tapAction(_ sender: Any) {
        tapLab.setText("Taped!")
    }
    
    @IBAction func longAction(_ sender: Any) {
        longLab.setText("Long Pressed!")
    }
    @IBAction func panAction(_ sender: Any) {
        panLab.setText("paned!")
    }
    @IBAction func swipeAction(_ sender: Any) {
        swipeLab.setText("Swiped!")
    }
}
