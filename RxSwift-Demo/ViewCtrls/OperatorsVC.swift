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
        flatMapTest()
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
    
    func mapTest() {
        
        Observable.of(1, 2, 3)
            .map { $0 * 10 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
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
    
}
