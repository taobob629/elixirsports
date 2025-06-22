项目名称：水滴电竞
开发环境：flutter版本  3.29.2 

iOS： flutter build ipa
android: flutter build apk --flavor arm64


1、升级xcode和macos以后iOS会编译报错：error: type 'UIApplication' does not conform to protocol 'Launcher'
extension UIApplication: Launcher {}
  解决方法：https://stackoverflow.com/questions/79013344/cannot-extend-uiapplication-to-conform-to-custom-protocol-in-xcode-16
          使用链接里面的最后一个解决办法可以解决，