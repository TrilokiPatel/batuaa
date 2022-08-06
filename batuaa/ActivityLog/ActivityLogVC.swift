//
//  ActivityLogVC.swift
//  batuaa
//
//  Created by Trilok Patel on 18/09/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class ActivityLogVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ActivityViewModel?
    var dataSource: ActivityDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = ActivityViewModel(viewDelegate: self)
        dataSource = ActivityDataSource(viewModel: self.viewModel!)
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.viewModel?.ActivityRestApi(parameter: [:])
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
        self.navigationController?.popViewController(animated: true)
    }
}
extension ActivityLogVC: ActivityViewDelegate {
    func responseRestAPI(object: [ActivityData]) {
        self.tableView.reloadData()
    }
    
    func showMsg(msg: String) {
        self.view.makeToast(msg, duration: 3.0, position: .top)
    }
    
    func showErrorMsg(msg: String) {
        self.view.makeToast(msg, duration: 3.0, position: .top)
    }
    
    func backLoginPage(msg: String) {
        popupAlertOnlyOkButton(title: "batuaa", message: msg) { success in
            if success {
                GlobalVariable.sharedInstance.showBack = true
                Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "NavVC", storyBoard: UIStoryboard(storyboard: .main))
                
            }
            
        }
        
    }
   
}
