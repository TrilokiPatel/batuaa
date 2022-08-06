//
//  AdvanceSettingVC.swift
//  batuaa
//
//  Created by Trilok Patel on 09/12/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class AdvanceSettingVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: AdvanceSettingViewModel?
    var dataSource: AdvanceSDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = AdvanceSettingViewModel()
        self.dataSource = AdvanceSDataModel(viewModel: self.viewModel!, nav: self.navigationController!)
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
