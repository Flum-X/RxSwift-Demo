//
//  ToObservable.swift
//  RxSwift-Demo
//
//  Created by Flum on 2021/12/6.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import Foundation

//让存储的属性可以变成一个可监测序列的属性包装器
@propertyWrapper struct ToObservable<T> {
    let observable: BehaviorSubject<T>
    var wrappedValue: T {
        didSet {
            self.observable.onNext(wrappedValue)
        }
    }

    init(wrappedValue: T) {
        observable = BehaviorSubject<T>.init(value: wrappedValue)
        self.wrappedValue = wrappedValue
    }
    
    //映射值
    public var projectedValue: Observable<T> {
        get {
            observable
        }
    }
}
