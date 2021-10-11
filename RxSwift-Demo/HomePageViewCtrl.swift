//
//  HomePageViewCtrl.swift
//  RxSwift-Demo
//
//  Created by Flum on 2021/10/11.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit

struct DataModel {
    let data = Observable.just([
        "tableView+Rx",
    ])
}

class HomePageViewCtrl: UIViewController {

    var tableView: UITableView!
    var viewModel = DataModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HomePage"
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
        
        //将数据源绑定到tableView上
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "HomeCell")) { _, text, cell in
            cell.textLabel?.text = text
        }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if indexPath.row == 0 {
                let vc = CataLogViewCtrl()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}
