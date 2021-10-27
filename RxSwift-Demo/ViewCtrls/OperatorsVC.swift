//
//  Operators.swift
//  RxSwift-Demo
//  常用操作符介绍
//  Created by Flum on 2021/10/27.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit
import RxSwift

class OperatorsVC: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bufferDemo()
    }

}

extension OperatorsVC {
    
    func bufferDemo() {
        
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
    
}
