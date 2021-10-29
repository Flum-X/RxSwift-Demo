//
//  CustomBindPropertyVC.swift
//  RxSwift-Demo
//  自定义可绑定属性
//  Created by Flum on 2021/10/20.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomBindPropertyVC: UIViewController {

    private var contentLb: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        bindEvent()
    }
    
    
    private func initUI() {
        view.backgroundColor = .white
        contentLb = UILabel()
        contentLb.textColor = .black
        contentLb.textAlignment = .center
        contentLb.text = "Hello World!"
        view.addSubview(contentLb)
        contentLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindEvent() {
        
        let observable = Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
        observable.map { CGFloat($0) }
        .bind(to: contentLb.rx.fontSize)
        .disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: UILabel {
    
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { lable, fontSize in
            lable.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
}
