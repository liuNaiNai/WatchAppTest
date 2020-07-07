//
//  AlertStyleController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/28.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchKit

class AlertStyleController: WKInterfaceController {
    @IBAction func alertAction() {
        let confirmAction = WKAlertAction(title: "Ok", style: .default) {
            print("Ok")
        }
        let denyAction = WKAlertAction(title: "Deny", style: .destructive) {
            print("Deny")
        }
        let cancelAction = WKAlertAction(title: "Cancel", style: .cancel) {
            print("Cancel")
        }
        presentAlert(withTitle: "Tip", message: "Do you want to see it.", preferredStyle: .alert, actions: [confirmAction, denyAction, cancelAction])
    }
    
    @IBAction func sideBySideAction() {
        let confirmAction = WKAlertAction(title: "Ok", style: .default) {
            print("Ok")
        }
        let denyAction = WKAlertAction(title: "Deny", style: .destructive) {
            print("Deny")
        }
        presentAlert(withTitle: "Tip", message: "Do you want to see it.", preferredStyle: .sideBySideButtonsAlert, actions: [confirmAction, denyAction])
        
    }
    @IBAction func sheetAction() {
        
        let confirmAction = WKAlertAction(title: "Ok", style: .default) {
            print("Ok")
        }
        let denyAction = WKAlertAction(title: "Deny", style: .destructive) {
            print("Deny")
        }
        let cancelAction = WKAlertAction(title: "Custom Cancel", style: .cancel) {
            print("Cancel")
        }
        presentAlert(withTitle: "Tip", message: "Do you want to see it.", preferredStyle: .actionSheet, actions: [confirmAction, denyAction, cancelAction])
    }
}
