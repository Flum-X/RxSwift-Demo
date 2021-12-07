//
//  CataLogViewCtrl.swift
//  RxSwift-Demo
//
//  Created by Flum on 2021/10/8.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit

struct Music {
    let name: String
    let singer: String
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

extension Music: CustomStringConvertible {
    var description: String {
        return "name: \(name) singer: \(singer)"
    }
}

struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
    ])
}

class CataLogViewCtrl: ViewController {

    var tableView: UITableView!
    var viewModel = MusicListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        
        //将数据源绑定到tableView上
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "musicCell")) { _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
        }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
                print("你选中的歌曲信息: \(music)")
        }).disposed(by: disposeBag)
    }

}
