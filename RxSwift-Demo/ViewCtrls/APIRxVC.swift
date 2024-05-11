//
//  APIRxVC.swift
//  RxSwift-Demo
//  用Rx封装接口
//  Created by yuqing on 2024/5/11.
//  Copyright © 2024 DaXiong. All rights reserved.
//

import UIKit

class APIRxVC: ViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        getUserInfoAndComments()
    }
    
    private func getUserInfo() {
        
        RxAPI.token(userName: "flum", password: "123456")
            .flatMapLatest(RxAPI.userInfo(token:)).subscribe { userInfo in
                DLog("获取用户信息成功：\(userInfo)")
            } onError: { error in
                DLog("获取用户信息失败：\(error)")
            }.disposed(by: disposeBag)
    }
    
    /// 同时获取用户信息和用户评论信息
    private func getUserInfoAndComments() {
        
        Observable.zip(//将2个网络请求合并成一个
            RxAPI.userInfo(userId: 1001),
            RxAPI.userContents(userId: 1001)
        ).subscribe { (userInfo, comments) in
            DLog("获取用户信息成功：\(userInfo)")
            DLog("获取用户评论成功：\(comments)")
        } onError: { error in
            DLog("获取用户信息或评论失败：\(error)")
        }.disposed(by: disposeBag)

    }
}

enum RxAPI {
    /// 通过用户名密码获得一个 token
    static func token(userName: String, password: String) -> Observable<String> {
        //网络请求
        let testToken = "test token"
        return Observable.just(testToken)
    }
    
    /// 通过token获得用户信息
    static func userInfo(token: String) -> Observable<UserInfo> {
        //网络请求
        let userInfo = UserInfo(userId: 1001, name: "flum", age: 18, level: 10)
        return Observable.just(userInfo)
    }
    
    /// 通过userId获取用户信息
    static func userInfo(userId: Int) -> Observable<UserInfo> {
        //网络请求
        let userInfo = UserInfo(userId: 1001, name: "flum", age: 18, level: 10)
        return Observable.just(userInfo)
    }
    
    /// 通过userId获取用户评价信息
    static func userContents(userId: Int) -> Observable<[Comment]> {
        //网络请求
        let comments = [Comment(content: "Good boy"), Comment(content: "handsome")]
        return Observable.just(comments)
    }
}

struct UserInfo {
    var userId = 0
    var name = ""
    var age = 0
    var level = 0
}

struct Comment {
    var content = ""
}
