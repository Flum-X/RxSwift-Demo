//
//  ConnectOperatorsVC.swift
//  RxSwift-Demo
//
//  Created by Flum on 2021/12/14.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit
import RxSwift

/// 可连接的序列：
/// 可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect() 之后才会开始发送值
/// 可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息
class ConnectOperatorsVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        publishTest()
        replayTest()
        multicastTest()
        refCountTest()
        shareReplayTest()
    }
    
    //MARK: publish
    /// publish方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始
    private func publishTest() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .publish()
        
        //第一个订阅者（立刻开始订阅）
        _ = interval.subscribe(onNext: {DLog("订阅1: \($0)")})
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval.subscribe(onNext: {DLog("订阅2: \($0)")})
        }
        
    }
    
    //MARK: replay
    /// 同样是将一个正常的序列转换成一个可连接的序列
    /// 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定)
    private func replayTest() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .replay(5)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval.subscribe(onNext: {DLog("订阅1: \($0)")})
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval.subscribe(onNext: {DLog("订阅2: \($0)")})
        }
    }
    
    //MARK: multicast
    /// 同样是将一个正常的序列转换成一个可连接的序列
    /// 同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送
    private func multicastTest() {
        
        let subject = PublishSubject<Int>()
        
        _ = subject
            .subscribe(onNext: { DLog("Subject: \($0)") })
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .multicast(subject)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval.subscribe(onNext: {DLog("订阅1: \($0)")})
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval.subscribe(onNext: {DLog("订阅2: \($0)")})
        }
    }
    
    //MARK: refCount
    /// refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
    /// 即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的 Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接
    private func refCountTest() {
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .publish()
            .refCount()
         
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { DLog("订阅1: \($0)") })
         
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { DLog("订阅2: \($0)") })
        }
    }
    
    //MARK: share(relay:)
    /// 该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者
    /// 简单来说 shareReplay 就是 replay 和 refCount 的组合
    private func shareReplayTest() {
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .share(replay: 5)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { DLog("订阅1: \($0)") })
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { DLog("订阅2: \($0)") })
        }
    }
    
}


/// 延迟执行
/// - Parameters:
///   - delay: 延迟时间
///   - closure: 延迟执行的闭包
public func delay(_ delay: Double, closure: @escaping ()->Void) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
