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
        ("Operators", "CommonOperatorsVC"),
        ("FilterOperators", "FilterOperatorsVC"),
        ("ConditionalOperators", "ConditionalOperatorsVC"),
        ("CombineOperators", "CombineOperatorsVC"),
        ("PolymericOperators", "PolymericOperatorsVC"),
        ("ConnectOperators", "ConnectOperatorsVC")
    ]

    let dataObservable = Observable.just(["tableView+Rx",
                                          "Observable",
                                          "CustomBindProperty",
                                          "Subjects",
                                          "Operators",
                                          "FilterOperators",
                                          "ConditionalOperators",
                                          "CombineOperators",
                                          "PolymericOperators",
                                          "ConnectOperators"
                                         ])
}

class HomePageViewCtrl: ViewController {

    var tableView: UITableView!
    var viewModel = DataModel()
    private let cellID = "HomeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HomePage"
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        //将数据源绑定到tableView上
        viewModel.dataObservable.bind(to: tableView.rx.items(cellIdentifier: cellID)) { _, text, cell in
            cell.textLabel?.text = text
        }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            let data = self.viewModel.datas[indexPath.row]
            if let vc =
                self.getVCInstance(stringName: data.1) {
                vc.title = data.0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}
