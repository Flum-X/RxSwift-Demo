//
//  ObservableVC.swift
//  RxSwift-Demo
//  Observable 订阅、事件监听、订阅销毁
//  Created by Flum on 2021/10/11.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit
import RxSwift

class ObservableVC: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        subscribeTest1()
//        subscribeTest2()
        observeLifeCycle()
    }
    
    private func subscribeTest1() {
        
        let observable = Observable.of("A", "B", "C")
        observable.subscribe { event in
            DLog(event)
            DLog(event.element)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeTest2() {
        
        let observable = Observable.of("A", "B", "C")
        observable.subscribe { element in
            DLog(element)
        } onError: { error in
            DLog(error)
        } onCompleted: {
            DLog("completed")
        } onDisposed: {
            DLog("disposed")
        }.disposed(by: disposeBag)
    }
    
    private func observeLifeCycle() {
        
        let observable = Observable.of("A", "B", "C")
        observable.do { element in
            DLog("do onNext" + element)
        } afterNext: { element in
            DLog("do after" + element)
        } onError: { error in
            DLog("do onError")
        } afterError: { error in
            DLog("do afterError")
        } onCompleted: {
            DLog("do onCompleted")
        } afterCompleted: {
            DLog("do afterCompleted")
        } onSubscribe: {
            DLog("do onSubscribe")
        } onSubscribed: {
            DLog("do onSubscribed")
        } onDispose: {
            DLog("do onDispose")
        }
        .subscribe { element in
            DLog("subscribe onNext" + element)
        } onError: { error in
            DLog("subscribe onError")
        } onCompleted: {
            DLog("subscribe onCompleted")
        } onDisposed: {
            DLog("subscribe onDisposed")
        }.disposed(by: disposeBag)

    }
    
}
