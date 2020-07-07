//
//  PickerController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/28.
//  Copyright © 2020 liukun. All rights reserved.
//

import UIKit
import WatchKit

class PickerController: WKInterfaceController {

    @IBOutlet weak var listPicker: WKInterfacePicker!
    @IBOutlet weak var stackPicker: WKInterfacePicker!
    @IBOutlet weak var sequencePicker: WKInterfacePicker!
    
    let dataArr: [WKPickerItem] = {
        var list = [WKPickerItem]()
        let titles = ["①", "②", "③", "④", "⑤"]
        let captions = ["one", "two", "three", "four", "five"]
        for i in 0...4 {
            let item = WKPickerItem()
            item.title = titles[i]
            item.caption = captions[i]
            let accessoryString = "item_type_\(i)"
            let contentString = "item_type_\(i + 1)"
            item.accessoryImage = WKImage(imageName: accessoryString)
            item.contentImage = WKImage(imageName: contentString)
            list.append(item)
        }
        return list
    }()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        listPicker.setItems(dataArr)
        stackPicker.setItems(dataArr)
        sequencePicker.setItems(dataArr)

    }
    
    @IBAction func listSelect(_ value: Int) {
        let item = dataArr[value]
        print("item.title = \(item.title!)")
    }
    @IBAction func stackSelect(_ value: Int) {
        let item = dataArr[value]
        print("item.title = \(item.title!)")
    }
    @IBAction func sequenceSelect(_ value: Int) {
        let item = dataArr[value]
        print("item.title = \(item.title!)")
    }
    
    override func pickerDidFocus(_ picker: WKInterfacePicker) {
        if picker == listPicker {
            print("ListPicker Did Focus")
        } else if picker == stackPicker {
            print("StackPicker Did Focus")
        } else {
            print("SequencePicker Did Focus")
        }
    }
    
    override func pickerDidResignFocus(_ picker: WKInterfacePicker) {
        if picker == listPicker {
            print("ListPicker Did Resign Focus")
        } else if picker == stackPicker {
            print("StackPicker Did Resign Focus")
        } else {
            print("SequencePicker Did Resign Focus")
        }
    }
    
    // 用户可以快速旋转数字表冠来滚动选择器中的项目。只有在滚动结束且值在一段合理的时间内保持稳定之后，才调用此方法。
    override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if picker == listPicker {
            print("ListPicker Did Settle")
        } else if picker == stackPicker {
            print("StackPicker Did Settle")
        } else {
            print("SequencePicker settle")
        }
    }
}
