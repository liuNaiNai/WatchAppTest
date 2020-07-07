//
//  ViewController.swift
//  WatchAppTest
//
//  Created by 刘坤 on 2020/6/28.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchConnectivity

let kWIDTH = UIScreen.main.bounds.size.width
let kHEIGHT = UIScreen.main.bounds.size.height
func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

class ViewController: UIViewController {
    
    lazy var receiveLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: kWIDTH - 100, height: 40.0)
        label.center = CGPoint(x: kWIDTH / 2.0, y: kHEIGHT / 3.0)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 6.0
        label.layer.masksToBounds = true
        label.text = "Receive Message..."
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 50.0, y: receiveLabel.center.y + 60.0, width: kWIDTH - 100.0, height: 40.0)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Input Message..."
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100.0, y: textField.center.y + 60.0, width: kWIDTH - 200.0, height: 44.0)
        button.backgroundColor = RGB(255.0, 128.0, 26.0)
        button.setTitle("Send To Watch", for: .normal)
        button.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        button.layer.cornerRadius = 6.0
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = RGB(204.0, 204.0, 204.0)
        configureWCSession()
        view.addSubview(receiveLabel)
        view.addSubview(textField)
        view.addSubview(sendButton)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    
    func configureWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        guard WCSession.default.isReachable else {
            print("Apple Watch is not reachable.")
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func sendAction() {
        let message = textField.text ?? ""
        sendMessegeToWatch(message: message)
        view.endEditing(true)
    }
    
    func sendMessegeToWatch(message: String) {
        guard WCSession.default.isReachable else {
            let alert = UIAlertController(title: "Failed", message: "Apple Watch is not reachable.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let message = ["title": "iPhone send a message to Apple Watch", "iPhoneMessage": message]
        WCSession.default.sendMessage(message, replyHandler: { (replyMessage) in
            print("回调1 = \(replyMessage)")
            DispatchQueue.main.sync {
                self.receiveLabel.text = replyMessage["replyContent"] as? String
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
    }
    
}

extension ViewController: WCSessionDelegate {

    func sessionDidBecomeInactive(_ session: WCSession) {
        print(session)
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print(session)
    }


    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            print(activationState)
        } else {
            print(error!.localizedDescription)
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from iPhone"])
        DispatchQueue.main.sync {
            self.receiveLabel.text = message["watchMessage"] as? String
        }
    }

}


