//
//  ViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/25/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = NSViewController
#endif

class ViewController: OSViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    /// 根据字符串获取对应的控制器实例
    /// - Parameter stringName: 类型字符串
    /// - Returns: <#description#>
    func getVCInstance(stringName: String) -> UIViewController? {
        //Swift中命名空间
        guard let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有命名空间")
            return nil
        }
        
        //如果你的工程名字中带有“-”符号,需要替换成“_”，否则会获取不到内容
        let newName = nameSpage.replacingOccurrences(of: "-", with: "_")
        guard let vcClass = NSClassFromString(newName + "." + stringName) else {
            print("没有获取到对应的class")
            return nil
        }
        
        guard let vcType = vcClass as? UIViewController.Type else {
            print("没有得到的类型")
            return nil
        }
        
        //根据类型创建对应的对象
        let vc = vcType.init()
        return vc
    }
}
