####前言
`Apple Watch`是苹果公司推出的一款比较成熟的智能手表，具有运动追踪、健康监测、消息推送、多媒体、游戏、定位等多种功能。`Apple Watch`需要配合`iPhone`手机使用，通过配对的`iPhone`访问应用商店进行第三方应用的下载和安装。`watchOS`是`Apple Watch`运行的操作系统，`watchOS`允许开发者使用`Objective-C`和`Swift`来开发应用。`Apple Watch`的应用和功能的开发还处在挖掘和探索阶段，希望能以本篇文章为契机，为有兴趣的开发者提供一些参考。

#### watchOS概述
1.`watchOS`项目结构
如今的`Apple Watch App`都要求是原生应用，原生应用即是高于`watchOS 2`及以上的版本，并作为一个完整的应用包在`Apple Watch`上独立运行,下图所示的是`watchOS App`的结构图
![watchOS App结构图.png](https://upload-images.jianshu.io/upload_images/1851080-418adf8c4f3c6c06.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
从上图可以看出`Xcode`项目包含三个部分分别是`iOS App`、`WatchKit App`、`WatchKitExtention`。`iOS App`负责`iPhone`端的所有运行内容，`WatchKit App`包含界面编辑和手表应用整体参数，`WatchKitExtention`包含`watch`端运行的代码及资源。`WatchKitExtention`包含在`WatchKit App`中，而手表端`App`和手机端`App`通过`WatchConnectivity`框架在` iOS`和 `watchOS`之间进行通信。在`watchOS 2`之前，应用安装的时候，负责逻辑部分的`WatchKitExtention`将随`iOS app`的主`target`被一同安装到`iPhone`中，而负责界面部分的`watchApp`将会在主程序安装之后由`iPhone`检测有没有配对的`Apple Watch`并提示安装到`watchApp`中。如今的`Apple Watch App`是作为一个完整的应用包在`Apple Watch`上独立运行

2.建立`watchOS App`实例
打开`xcode commond+ shift+ N`新建一个`project`，选中`watchOS`下的`iOS App with Watch App`。项目建立成功之后可以看到如下
![Xcode项目结构.png](https://upload-images.jianshu.io/upload_images/1851080-c68ce5bd78091f41.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
从上图可以看出`watchOS`手表扩展包`Extention`包含四个文件
2.1.页面`InterfaceController`：继承`WKInterfaceController`，默认有三个函数，分别在不同的时机由系统调用；初始化时调用`awake(withContext context: Any?)`；页面显示时调用` willActivate()`,失活状态调用`didDeactivate()`

2.2.扩展代理`ExtensionDelegate`：继承手表扩展代理`WKExtensionDelegate`，这与`iOS`中的`AppDelegate`有异曲同工之妙。应用启动完成后初始化时调用`applicationDidFinishLaunching()`,应用激活前台时调用`applicationDidBecomeActive()`，应用失活时调用`applicationWillResignActive()`,应用被系统后台启动时调用`handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>)`

2.3.通知界面`NotificationController`:手表接到通知时单击通知按钮显示的页面，通知页面有一个接到通知的处理函数`didReceive(_ notification: UNNotification)`默认该函数的标注是用状态，当要页面动态显示内容时才调用该函数。`WatchKit`的通知允许开发者自行构建界面，`WatchKit App` 接收到通知后先会显示一个简短的通知，告诉用户这个 app 有一个通知。如果用户对通知的内容感兴趣的话，可以点击或者抬手观看，这样由开发者自定义的长版本的通知就会显现.

2.4.表盘功能`ComplicationController`:负责表盘功能栏的设置，里面包含了多个函数分别对应显示功能栏的不同时机，其中最常用的直接设置表盘功能栏函数是`getCurrentTimelineEntry`，设置`iPhone Watch`里的功能栏示例的函数是`getLocalizableSampleTemplate`


3.`WKInterfaceController`的完整生命周期如下：
![生命周期.png](https://upload-images.jianshu.io/upload_images/1851080-cd798b87543b302e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
页面的生命周期：当你进入一个页面时, 设备会经历`init`->`awakeWithContext`->`willActivate`->`didAppear`。当你退出当前页面时, 设备会经历`willDisappear`->`didDeactivate`->`deinit`

4.基础导航：
4.1.`WKInterfaceController` 的内建的导航关系基本上分为三类。首先是像 `UINavigationController `控制的类似栈的导航方式。相关的 API 有 -      `pushControllerWithName:context:`，`-popController `以及 -`popToRootController。`对于第一个方法，我们需要使用目标 `controller` 的` Identifier `字符串 (你只能在 `StoryBoard` 里进行设置) 进行创建。`context` 参数也会被传递到目标 `controller` 的 -`initWithContext: `中，所以你可以以此来在 `controller` 中进行数据传递。
![栈导航.png](https://upload-images.jianshu.io/upload_images/1851080-9e9fb444e7952a04.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

4.2.另一种是我们大家熟悉的 modal 形式，对应 API 是 -`presentControllerWithName:context:` 和 `-dismissController`。对于这种导航，和 UIKit 中的不同之处就是在目标 `controller` 中会默认在左上角加上一个 `Cancel` 按钮，点击的话会直接关闭被 present 的 `controller`。

4.3.最后一种导航方式是类似 `UIPageController` 的分页式导航.在实现上，page 导航需要在 `StoryBoard` 中用 `segue` 的方式将不同 `page` 进行连接，新添加的 `next page segue` 就是干这个的
![Page-based.png](https://upload-images.jianshu.io/upload_images/1851080-4d2e805525539180.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 布局与适配
`Watch app` 的布局和 `iOS` 的布局完全不同。你无法自由指定某个视图的具体坐标，当然也不能使用`AutoLayout`或者`SizeClasses`这样灵活的界面布局方案。`WatchKit`提供的布局可能性和灵活性相对较小，你只能在以"行"为基本单位的同时通过`Group`来在内进行“列”布局。首先所有的`WKInterfaceObject`对象都必须要设计的时候经`storyboard`进行添加，运行时我们无法再向界面上添加或者移除元素，如果有移除的可以使用隐藏。基本来说在运行时我们只能够改变视图的内容，以及通过隐藏某些元素来达到有限改变布局的效果。

`Group`: `WatchOS`中的一个很特别的类, 它是一个容器性质的控件, 能为其他控件提供额外的布局。可以指定其所包含控件的排列方向, 横向或者纵向或者重叠, 也可以设置间距和内嵌。它还能为自己添加背景图片, 作为一个种控件叠加的效果这是一个不错的选择, 因为在 `watchOS`中是不允许控件相互重叠的, 除了像`Group`这样容器类的控件

`Assets`：在`WatchKit App`、`WatchKitExtention`都可以放置图片资源，只是加载的方式不同，放在`WatchKit App Assets.xcassets`里面的图片要用`setImageNamed(_ imageName: String?)`加载显示，而在`WatchKitExtention`里面的图片需要使用`setImage(_ image: UIImage?)`来加载。推荐放在`WatchKit App Assets.xcassets`

`icon设计`：您必须提供在`iPhone`和`Apple Watch`主屏幕上均可使用的图标资源，同时该图标为不含透明`alpha`通道的`png`图。[官方给出的尺寸标准戳这里](https://developer.apple.com/design/human-interface-guidelines/watchos/icons-and-images/image-optimizations)


#### 证书配置
证书的配置是开发过程中必不可少的一个环节，虽然`Xcode`也可以自动配置证书生成`App ID`，但是作为一个开发人员还是有必要了解下证书配置流程。下面简单的记录了`AppleWatch`开发过程中需要用到的证书以及`App ID`配置，根据项目需要自行选择是否加入`App Groups`
1.准备`App ID`
 主 `App ID`：   `com.**.**`
`watch AppID`： `com.**.**.watchkitapp`
`watch extension AppID`:  `com.**.**.watchkitapp.watchkitextension`
![App ID规范.png](https://upload-images.jianshu.io/upload_images/1851080-c23ff16726eb8c31.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2.准备`provisioning profiles`，给`watch AppID`和`watch extension AppID`配置开发和生产的`provisioning profiles`
开发和生产`provisioning profiles`如下：
![描述文件.png](https://upload-images.jianshu.io/upload_images/1851080-b67112fe581e0466.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
#### 基本控件的使用
1.`WKInterfaceLabel`、`WKInterfaceButton`、`WKInterfacePicker`、`WKInterfaceTable`、`WKInterfaceSwitch`、`WKInterfaceSlider`等在`iOS`中也有，这里就不赘述

2.`WKInterfaceImage`:关于图片的使用有一个坑需要注意, 当我们为其添加图片时, 可能会遇到图片不显示的问题。这是因为所使用的方法和图片资源库是有一定的关系的。当使用`setImageNamed:`或`setBackgroundImageNamed:`方法添加图片时, 应该使用 `Watch App`包内`Assets.xcassets中`的已有的图片资源;当使用`setImage:`、`setImageData:`、`setBackgroundImage:`或`setBackgroundImageData:`方法添加图片时, 应该使用 `WatchKit Extension`包内`Assets.xcassets`中的图片资源。使用后者方式时, 会先在` WatchKit Extension`中创建` Image`, 然后再传输到 `WatchKit App`中进行显示

3.`WKInterfaceTable`：可以显示多行类型相同的内容，每一行的内容都需要在代码中设置，并且还要自定义行的标识`identifier`和类，该类继承于`NSObject`，最后设置表格的行数和每一行的序列号和内容，如果显示类型不同的内容，可以使用`setRowTypes(_ rowTypes: [String])`来指定不同的类型的标识`identifier`
```
   table.setNumberOfRows(dataArray.count, withRowType: "ItemRowController")
   for (i, info) in dataArray.enumerated() {
         let cell = table.rowController(at: i) as! ItemRowController
         cell.titleLabel.setText(info["title"])
         cell.image.setImageNamed(info["image"])
     }
```
4.`Context Menu`：另一个比较好玩的是 `Context Menu`，这是 `WatchKit` 独有的交互，在 `iOS` 中并不存在。在任意一个` WKInterfaceController` 界面中，长按手表屏幕，如果当前 `WKInterfaceController` 中存在上下文菜单的话，就会尝试呼出找这个界面对应的 `Context Menu`。这个菜单最多可以提供四个按钮，用来针对当前环境向用户征询操作。添加 `Context Menu` 非常简单，在 `StoryBoard `里向 `WKInterfaceController` 中添加一个 `Menu`，并在这个 `Menu` 里添加对应的 `MenuItem` 就行了。在 `WKInterfaceController` 我们也有对应的 API 来在运行时根据上下文环境进行 `MenuItem `的添加 (这是少数几个允许我们在运行时添加元素的方法之一)
```
-addMenuItemWithItemIcon:title:action:
-addMenuItemWithImageNamed:title:action:
-addMenuItemWithImage:title:action:
-clearAllMenuItems
```
![Context Menu.png](https://upload-images.jianshu.io/upload_images/1851080-63375bb3e96eccce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5.`WKGestureRecognizer`: `Tap  LongPress  Pan  Swipe`

6.`Alert`: `WKAlertControllerStyle`有三种类型，分别是`alert`, `sideBysideButtonAlert`，`actionSheet`，样式如下
![alert 类型.png](https://upload-images.jianshu.io/upload_images/1851080-443e13e6276b5ae3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

7.`WKInterfacePicker`：`WKInterfacePicker`的`style`有`list, stack, sequence`三种(具体样式见下图)(`title`和`accessoryImage`只有在类型为`list`才有用)`Focus Style`属性也有三种，分别是`None Outline  outline with Caption`；同时系统也提供获取当前选项序列号`value`的点击事件.使用选择器时需要预先设置显示的选择项，选择项为`WKPickerItem`,每一项可以包括`title`和图标`contentImage`，使用`listPicker.setItems(itemArray)`赋值。
![image.png](https://upload-images.jianshu.io/upload_images/1851080-8a8f88ff877da780.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####与iPhone交互
 `WatchOS`提供框架`WatchConnectivity`进行`Watch`和`iPhone`之间的数据交换，支持后台传输和前台传输。`WatchConnectivity`提供了一个`WCSesion`对象，通过`WCSession`进行数据传输。配置`WCSession` --> 判断连接状态 -->数据传输
1.准备工作：手表和手机配对，如果单独从模拟器中启动【iPhone 模拟器】 和 【Apple Watch 模拟器】是不能配对的，正确的配对方式是
1.1. 在对应的模拟器中添加配对的手表
![模拟器配对.png](https://upload-images.jianshu.io/upload_images/1851080-3a9eac6d6f74c3fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
1.2. 启动`iPhone`模拟器
1.3. 启动手表模拟器
1.4. 打开`iPhone`模拟器上的手表应用就可以看到已经配对了
![image.png](https://upload-images.jianshu.io/upload_images/1851080-f05e739e4df52abc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


2.配置`WCSession`：在`Watch Extention`端和`iPhone`端都要先找到默认的`WCSession`对象，并设置代理，激活`activate`

3.判断连接状态： 在输出数据时需要判断`Watch`和`iPhone`的连接状态，`WCSession`提供了如下状态是否配对`isPaired`、手表端应用是否安装`isWatchAppInstalled`、两者间消息是否能相通`isReacheable`。当`Watch`已经配对且`Watch`端应用安装好时，可以进行后台传输数据；当两者`isReacheable = true`时，可以直接进行前台数据传输。

4.数据传输:  `WatchKit Extention`与`iPhone`间通信的方式有很多种，可以分为前台实时传输和后台不定时传输两大传输类型。前台传输，是实时传输<消息字典传输、消息数据传输>，后台传输又分为覆盖式传输、队列式传输<字典传输、文件传输、表盘数据传输>
![通信方式.png](https://upload-images.jianshu.io/upload_images/1851080-163bfc22b7d65d5c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5.前台消息字典传输 :从 `WatchKit Extension`激活并运行时调用此方法会在后台唤醒相应的 `iOS App`并使其可访问,但若从 `iOS App`调用此方法则不会唤醒相应的`WatchKit Extension`。判断信息可达`isReachable`,对于 `WatchKit Extension`来说, `iOS`设备在范围内, 并且 `WatchKit Extension`在前台运行。对于 `iOS`来说, 配对且激活的 `Apple Watch`在范围内, 相应的`WatchKit Extension`正在运行。只要这样`isReachable`属性才会为`true`。<当传输的消息字典中包含非属性列表数据类型, 也会调用`errorHandlerblock`>

6.前台消息数据传输：此方法与消息字典传输的方法的区别在于所传输的主体内容为`Data`类型。包含非属性列表数据类型的传输

7.后台覆盖式传输：后台传输不适合数据立即传输，而是当具备数据传输连接条件以后`watch`和`iPhone`之间自动同步数据，所以后台传输的数据是异步传输的，具有延后性 覆盖式后台传输时使用的方法是`updateApplicationContext`，当第一次发送的数据还没有传送出去时，如果此时进行第二次数据传输，会覆盖第一次的数据，而真正传输的是第二次的数据，第一次的数据会丢失。当接收完毕时会调用代理`WCSessionDelegate`的方法`session: didReceiveApplicationContex: `，系统会把接收的数据存放在`WCSession`的属性`receivedApplicationContext`中以供我们需要时读取

8.后台队列式字典传输: 此方法可以传输一个字典, 系统将`userInfo`字典按序排入队列, 并在适当的时候将其传输到接收方应用中。你还可以通过`outstandingUserInfoTransfers`属性来获取仍在传输中(即未被接收方取消, 失败或已接收)的`userInfo`数组。

9.后台队列式文件传输:此方法可以传输一个文件和一个可选字典, 且只有在`Session`处于激活状态时才能调用此方法。你还可以通过`outstandingFileTransfers`属性来获取仍在传输中(即未被接收方取消, 失败或已接收)的`userInfo`数组。

10.后台队列式表盘数据传输:此方法涉及到` WatchOS`的表盘功能也就是`Complication`功能, 且只适用于` iPhone`向 `WatchKit Extension`发送表盘功能相关的数据。此方法将包含表盘功能的最新信息的字典`userInfo`排入队列中

11.以下展示了手表端和手机端如何通过`WatchConnectivity`框架进行前台数据传输
```
   // 手表端
    WCSession.default.sendMessage(message, replyHandler: { (replyMessage) in
        print("回调2 replyMessage = \(replyMessage)")
        DispatchQueue.main.sync {
            self.receiveLab.setText(replyMessage["replyContent"] as? String)
        }
    }) { (error) in
        print(error.localizedDescription)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from watch"])
        DispatchQueue.main.sync {
            contentLabel.setText(message["iPhoneMessage"] as? String)
        }
    }
```
```
  // 手机端
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

     func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from iPhone"])
        DispatchQueue.main.sync {
            receiveLabel.text = message["watchMessage"] as? String
        }
    }
```
####表盘功能栏
`Complications` 是 `watchOS 2` 新加入的特性，它是表盘上除了时间以外的一些功能性的小部件[官方文档](https://developer.apple.com/design/human-interface-guidelines/watchos/app-architecture/complications/)给出了所有的模板类型示意图

根据用户表盘选择的不同，表盘上对应的可用的 `complications` 形状也各不相同。如果你想要你的 `complication` 在所有表盘上都能使用的话，你需要实现所有的形状。掌管 `complications` 或者说是表盘相关的框架并不是我们一直使用的` WatchKit`，而是一个 `watchOS 2` 中全新框架`ClockKit`。`ClockKit `会提供一些模板给我们，并在一定时间点向我们请求数据。我们依照模板使用我们的数据来实现 complication，最后 `ClockKit `负责帮助我们将其渲染在表盘上。在 `ClockKit `请求数据时，它会唤醒我们的 `watch extension`。我们需要在 `extension` 中实现数据源，并以一段时间线的方式把数据提供给 `ClockKit`。这样做有两个好处，首先 `ClockKit` 可以一次性获取到很多数据，这样它就能在合适的时候更新` complication` 的显示，而不必再次唤醒 `extension` 来请求数据。其次，因为有一条时间线的数据，我们就可以使用 `Time Travel` 来查看 `complication` 已经过去的和即将到来的状况，这在某些场合下会十分方便。

`getCurrentTimelineEntryForComplication:withHandler:`，我们需要通过这个方法来提供当前表盘所要显示的 `complication`。`getTimelineStartDateForComplication:withHandler: `和`getTimelineEndDateForComplication:withHandler:` 来告诉系统我们所能提供 `complication` 的日期区间另外，我们还可以通过实现`getLocalizableSampleTemplate:withHandler:`来提供一个在表盘定制界面是会用到的占位图像
![complication.png](https://upload-images.jianshu.io/upload_images/1851080-4363ed65c1db12ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####通知
当手机收到应用通知时，如果手机息屏手表就会收到通知推送，当前手表必须连接蓝牙或`WiFi`。通知页面分为静态和动态两种，可以在`storyboard`页面中见到，同时可以在`NotificationController`的方法`didReceive()`中设置动态内容
####多媒体
从2.0开始，`watchOS`开放了多媒体`API`，包括前台录音，无线播放音频，视频播放器，其中视频播放器使用喇叭外放声音
1.录音：录音文件的扩展名只能取`.wav .mp4 .m4a`，若设置成其他的则会报错。录音文件要保存在组目录中,记录保存的地址，以供以后播放
2.无线播放音频：采取无线蓝牙播放时系统会提示`AirPlay`确认连接，播放时依次按照音频文件`URL`、`AVAsset`、`AVPlayerItem`的顺序进行构建
3.视频播放： 支持播放音频和视频，这里使用视频播放器实现。视频播放器不支持在线视频
####运动传感器和GPS
![运动.png](https://upload-images.jianshu.io/upload_images/1851080-c276cb942b3a5fb7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`Apple Watch`配备了加速计和陀螺仪，我们可以通过`CMMotionManager`来获取相关上述两种传感器的监控数据
1.加速计: 负责检测运动的加速度值，分为`XYZ`三个方向，当单独启动加速计时，重力加速度会默认附加在`Z`方向，值为-1.0。启动加速计之前，先要设定加速计的监控刷新时间间隔`accelerometerUpdateInterval`,该间隔确定了多久刷新一次数据。获取数据分为两种方式，如果要在获取数据之后立即处理，就使用函数回调的方式`startAccelerometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAccelerometerHandler)`，此方法会在后台加速计获取新数据后立即执行`withHandler`；如果只是在需要的时候查询数据，需要读取`CMMotionManager`的属性`accelerometerData`来获取加速数据。检测设备是否支持加速计，可用`CMMotionManager`的属`isAccelerometerActive`

2.陀螺仪：`Gyroscope`负责检测旋转运动的旋转速度，同加速器启动方式相同

3.地磁仪： 可以检测磁场强度，但是支持的设备比较少，所以在启用前先查看`isMagnetometerAvailable`检测本设备是否支持，同加速器启动方式相同。先设置间隔`magnetometerUpdateInterval`再调用启动方法`startMagnetometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMMagnetometerHandler)`

4.设备运动: 启动设备运动`Device motion`就表示将设备上所有的运动传感器全部启动，可以获取所有的运动数据，包括重力加速度`gravity`、用户加速度`userAcceleration`，旋转角度`attitude`，旋转速率`rotationRate`，磁场`magneticField`

5.运动姿势识别: `CoreMotion`框架还包括对设备运动姿势`MotionActivity`的识别，静止`stationary`、步行`walking`、跑步`running`、汽车`automotive`、自行车`cycling`的真假状态。通过`CMMotionActivityManager`的`startActivityUpdates(to queue: OperationQueue, withHandler handler: @escaping CMMotionActivityHandler)`方法启动刷新检测

6.GPS和定位： 可以调用手表中的`CoreLocation`来获取位置信息，与`iOS`中的相同，根据定位服务的使用方式，需要在`info.plist`配置相应的权限描述字段，使用方式与手机相同

####健康
![健康.png](https://upload-images.jianshu.io/upload_images/1851080-912e939720aaf82c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`AppleWatch`提供强大和全面的健康监测功能，如心率、步数、活动能量消耗等，同时`AppleWatch`会将监测到的健康数据先存储在`Watch`端的健康库中；然后略微延迟的发送到`iPhone`端的健康库中，我们打开`iPhone`上的健康应用就能看到检测到的各种数据；最后等过一段时间大概是一天之后，`Watch`端会将旧的数据自动删除以便节省存储空间来存储新数据，通过函数`earliestPermittedSampleDate()`可以获取`Watch`端保存的最旧数据的时间。健康是一个系统级的框架`HealthKit`。该框架涉及两个应用--“健康”和"健身记录",其中大部分数据监测都可在"健康"中访问，而“健身记录”可以访问有关"体能训练"的数据。

健康框架`HealthKit`具有一个健康库`HealthStore`，此`HealthStore`负责健康数据的存储、管理和访问，同时也负责健康管理器的管理工作。`HealthStore`存储的数据包括__人体特性数据 样本数据 和病例__

1.人体特征数据： 生日/年龄、血型、性别。特征数据`Characteristic data`可以通过`HealthStore`直接获得，不必经过复杂查询操作
2.样本数据`HKSample`: 心率、行走步数、能量消耗等。`HKSample`具有对应的开始时间、结束时间和数据类型。同时分为四个子类
2.1.样本类别`HKCatagorySample`：以状态变化为标志的数据，如睡眠和醒着两种状态
2.2.数量样本`HKQuantitySample`：数值表示如心率为65bmp,涉及对应数量单位`HKUnit`，如米（`HKUnit.meter()`）、次/分钟（`HKUnit(from: "count/min")`）
2.3.关联样本`HKCorrelation`:不同数据关联起来放在一起，如心率和能量消耗两个数据关联的样本
2.4.体能训练`HKWorkout`：运动类型、位置、起始时间、距离、能量消耗是`HKWorkout`必须要包含的基本数据，步数、平均心率、`metaData`等其他是额外附加数据。`HKWorkout`通过`Watch`端的体能训练作业`HKWorkoutSession`来检测，`HKWorkoutSession`可以在手表端创建和激活，激活后`Watch`的健康传感器就会开始工作（耗电较多），全面检测步数、能量消耗、心率等数据，并且将自动检测到的数据以`HKQuantitySample`的形式存储起来并发送到手机端。我们需要手动将体能训练`HKWorkout`及其相关的数据保存到健康库`HealthStore`中，存储的体能训练可以在手机“健身记录”里查看
2.5. 样本数据类型：为了区别各种数据的不同类型，健康库`HealthStore`通过健康数据类型`HKObjectType`来表示数据的类型，而`HKObjectType`又是通过响应的类型标识`identifier`来确定的。[官方文档介绍戳这里](https://developer.apple.com/documentation/healthkit/hkobjecttype)
2.6.病例：健康库`HealthStore`可以通过第三方应用添加病例文件`CDA`，用户可以通过“健康”应用查看和管理病例文件病例主要通过手机操作
2.7. 加载健康： `Apple`产品使用健康功能是通过`HealthKit Framework`实现，所以需要再`xcode`项目中的`Capabilities`开启`HealthKit`即可。`Apple Watch`检测健康数据涉及到个人隐私，所以需要申请相应的权限，在`info.plist`中添加键值对`NSHealthUpdateUsageDescription` `NSHealthShareUsageDescription`。
2.8.后台模式： 手表在使用时很可能会黑屏或者切换到时间表盘，为了能够持续不断的检测，应用需要开启后台运行模式。在`xcode`的`extention`项目的`Capabilities`打开`background modes`,勾选`workout processing`


####写在最后
以上章节的实例代码[Demo戳这里](https://github.com/liuNaiNai/WatchAppTest/tree/master)
以`Apple Watch`为代表的智能穿戴产品虽然远远不如手机那么普及，但是随着设备的进一步成熟和 `SDK` 的更加开放，`Apple Watch `开发也逐渐趋于稳定。我想我们最好能不断跟紧`watch`开发的脚步，尽量多的积累，这样才会在以后的道路上取得先机。












