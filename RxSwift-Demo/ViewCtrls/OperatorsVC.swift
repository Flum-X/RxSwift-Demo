//
//  Operators.swift
//  RxSwift-Demo
//  常用操作符介绍
//  Created by Flum on 2021/10/27.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class OperatorsVC: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        bufferTest()
//        windowTest()
//        mapTest()
//        flatMapTest()
//        flatMapLatestTest()
//        flatMapFirstTest()
//        concatMapTest()
//        scanTest()
        groupByTest()
    }

}

extension OperatorsVC {
    
    func bufferTest() {
        
        let subject = PublishSubject<String>()
        
        subject
            .buffer(timeSpan: .seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext:{ print($0) })
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onCompleted()
    }
    
    func windowTest() {
        
        let subject = PublishSubject<String>()
        
        subject
            .window(timeSpan: .seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                print("subscribe: \($0)")
                $0.asObservable()
                    .subscribe(onNext: {
                        print($0)
                    }).disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onCompleted()
    }
    
    //MARK: Map 该操作符通过传入一个函数闭包把原来的Observable序列转变为一个新的Observable序列
    /// 该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列
    func mapTest() {
        
        Observable.of(1, 2, 3)
            .map { $0 * 10 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //MARK: flatMap
    /// map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列
    /// 而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列
    /// 这个操作符是非常有用的。比如当 Observable 的元素本身拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来
    func flatMapTest() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let relay = BehaviorRelay(value: subject1)
        
        relay.asObservable()
            .flatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        relay.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    //MARK: flatMapLatest
    /// flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件
    func flatMapLatestTest() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let relay = BehaviorRelay(value: subject1)
        
        relay.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        relay.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    //MARK: flatMapFirst
    /// flatMapFirst 与 flatMapLatest 正好相反：flatMapFirst 只会接收最初的 value 事件
    func flatMapFirstTest() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let relay = BehaviorRelay(value: subject1)
        
        relay.asObservable()
            .flatMapFirst { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        relay.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    //MARK: concatMap
    /// concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅
    func concatMapTest() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let relay = BehaviorRelay(value: subject1)
        
        relay.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        relay.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
        
        //只有前一个序列结束后，才能接收下一个序列
        subject1.onCompleted()
    }
    
    //MARK: scan
    /// scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
    func scanTest() {
        
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, elem in
                acum + elem
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //MARK: groupBy
    /// groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来
    /// 也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来
    func groupByTest() {
        
        Observable<Int>.of(0, 1, 2, 3, 4, 5)
            .groupBy { element->String in
                return element % 2 == 0 ? "偶数" : "奇数"
            }
            .subscribe { [weak self] event in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ event in
                        print("key: \(group.key) event: \(event)")
                    }).disposed(by: self!.disposeBag)
                default:
                    print("")
                }
            }
            .disposed(by: disposeBag)
    }
}
