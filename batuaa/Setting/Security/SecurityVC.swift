//
//  SecurityVC.swift
//  batuaa
//
//  Created by Trilok Patel on 04/08/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class SecurityVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: SecurityViewModel?
    var dataSource: SecurityDataSource?
//    var navigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = SecurityViewModel()
        self.dataSource = SecurityDataSource(viewModel: self.viewModel!, nav: self.navigationController!)
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(self.copyMessage(_:)), name: NSNotification.Name(rawValue: "advanceSetting"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "advanceSetting"), object: nil)
    }
    @objc func copyMessage(_ notification: NSNotification) {
        self.tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = self.tabBarController as! TabbarController
        tabBar.hideTabBar()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         let tabBar = self.tabBarController as! TabbarController
        tabBar.showTabBar()
    }
    
    @IBAction func backButton(_ sender: Any) {
//        navigationController
        self.navigationController?.popViewController(animated: true)
//        self.t
        
    }
    
}
