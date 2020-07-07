//
//  MessageController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/29.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity

class MessageController: WKInterfaceController {
    @IBOutlet weak var receiveLab: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let session = WCSession.default
        session.delegate = self
        session.activate()
    
    }
    
    @IBAction func sendMsgAction() {
        guard WCSession.default.isReachable else {
            let action = WKAlertAction(title: "OK", style: .default) {
                print("OK")
            }
            presentAlert(withTitle: "Failed", message: "Apple Watch is not reachable.", preferredStyle: .alert, actions: [action])
            return
        }
        
        let date = Date()
        let message = ["title": "Apple Watch send a messge to iPhone", "watchMessage": "The Date is \(date.description)"]
        WCSession.default.sendMessage(message, replyHandler: { (replyMessage) in
            print("回调2 replyMessage = \(replyMessage)")
            DispatchQueue.main.sync {
                self.receiveLab.setText(replyMessage["replyContent"] as? String)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
extension MessageController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            print(activationState)
        } else {
            print(error!.localizedDescription)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print(session)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from watch"])
        DispatchQueue.main.sync {
            self.receiveLab.setText(message["iPhoneMessage"] as? String)
        }
    }
}
