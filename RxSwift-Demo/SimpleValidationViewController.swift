//
//  SimpleValidationViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit

private let minimalUsernameLength = 6
private let minimalPasswordLength = 8

class SimpleValidationViewController : ViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!

    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!

    @IBOutlet weak var doSomethingOutlet: UIButton!

    private var viewModel: SimpleValidationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SimpleValidationViewModel(username: usernameOutlet.rx.text.orEmpty.asObservable(), password: passwordOutlet.rx.text.orEmpty.asObservable())
        
        viewModel.usernameValid.bind(to: passwordOutlet.rx.isEnabled).disposed(by: disposeBag)
        viewModel.usernameValid.bind(to: usernameValidOutlet.rx.isHidden).disposed(by: disposeBag)
        viewModel.passwordValid.bind(to: passwordValidOutlet.rx.isHidden).disposed(by: disposeBag)
        viewModel.allValid.bind(to: doSomethingOutlet.rx.isEnabled).disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap.subscribe(onNext: { [weak self] in
            self?.gotoHomePage()
            }).disposed(by: disposeBag)
    }

//    func showAlert() {
//        
//        let alertCtr = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
//        alertCtr.addAction(cancelAction)
//        self.present(alertCtr, animated: true, completion: nil)
//    }

    func gotoHomePage() {
        
        let vc = UINavigationController(rootViewController: HomePageViewCtrl())
        AppDelegate.shared()?.setRootViewCtrl(vc)
    }
}

class SimpleValidationViewModel {
    
    //输出
    let usernameValid: Observable<Bool>
    let passwordValid: Observable<Bool>
    let allValid: Observable<Bool>
    
    //输入 -> 输出
    init(username: Observable<String>, password: Observable<String>) {
        
        usernameValid = username.map { $0.count >= minimalUsernameLength }.share(replay: 1, scope: .whileConnected)
        passwordValid = password.map { $0.count >= minimalPasswordLength }.share(replay: 1, scope: .whileConnected)
        allValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }.share(replay: 1, scope: .whileConnected)
        
    }
}
