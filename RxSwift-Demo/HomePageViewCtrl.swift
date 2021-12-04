//
//  HomePageViewCtrl.swift
//  RxSwift-Demo
//
//  Created by Flum on 2021/10/11.
//  Copyright © 2021 DaXiong. All rights reserved.
//

import UIKit

/// 数据源
struct DataModel {
    
    var datas = [//(行title, 点击跳转类名)
        ("tableView+Rx", "CataLogViewCtrl"),
        ("Observable", "ObservableVC"),
        ("CustomBindProperty", "CustomBindPropertyVC"),
        ("Subjects", "SubjectsVC"),
        ("Operators", "OperatorsVC")
    ]

    let dataObservable = Observable.just(["tableView+Rx",
                                          "Observable",
                                          "CustomBindProperty",
                                          "Subjects",
                                          "Operators"
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
        viewModel.dataObservable.bind(to: tableView.rx.items(cellIdentifier: "HomeCell")) { _, text, cell in
            cell.textLabel?.text = text
        }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            let data = self.viewModel.datas[indexPath.row]
            if let type =
                NSClassFromString(data.1) as? UIViewController.Type {
                let vc = type.init()
                vc.title = data.0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}
