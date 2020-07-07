//
//  ProgressController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/29.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchKit

class ProgressController: WKInterfaceController {
    @IBOutlet weak var backGroup: WKInterfaceGroup!
    
    @IBOutlet weak var picker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // 通过不断改变group的背景图片
        var images = [UIImage]()
        var pickerItems = [WKPickerItem]()

        for i in 0...100 {
            let name = "activity-\(i)"
            images.append(UIImage(named: name)!)

            let pickerItem = WKPickerItem()
            pickerItem.title = "No.\(i)"
            pickerItems.append(pickerItem)
        }

        let progressImages = UIImage.animatedImage(with: images, duration: 0)
        backGroup.setBackgroundImage(progressImages)
        // 遵循WKImageAnimatable协议的对象数组,数组中的对象展示动画图像
        picker.setCoordinatedAnimations([backGroup])
        picker.setItems(pickerItems)
    }
    
}
