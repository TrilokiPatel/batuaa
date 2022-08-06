//
//  BankAccountsVC.swift
//  batuaa
//
//  Created by Trilok Patel on 25/11/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class BankAccountsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: BankAccountViewModel?
    var dataSource: BankAccountDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = BankAccountViewModel(viewDelegate: self)
        self.dataSource = BankAccountDataSource(viewModel: self.viewModel!, navigation: self.navigationController!,tableView: self.tableView, delegate: self)
       
        //self.dataSource = BankAccountDataSource(viewModel: self.viewModel!, navigation: self.navigationController!, tableView: self.tableView)
        
        self.tableView?.register(UINib(nibName: "BankTableCell", bundle: nil), forCellReuseIdentifier: "BankTableCell")
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0);

        self.tableView.register(
            BankHeaderView.nib,
            forHeaderFooterViewReuseIdentifier:
                BankHeaderView.reuseIdentifier
        )
        self.viewModel?.callBankAccountRestApi(parameter: [:])
        NotificationCenter.default.addObserver(self, selector: #selector(self.copyMessage(_:)), name: NSNotification.Name(rawValue: "editSetting"), object: nil)
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "editSetting"), object: nil)
    }
    @objc func copyMessage(_ notification: NSNotification) {
        self.viewModel?.callBankAccountRestApi(parameter: [:])
        
    }
    @IBAction func BackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension BankAccountsVC: BankAccountViewModelDelegate {
    func responseRestAPI(object: BankAccountData?) {
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    func showMsg(msg: String) {
        
    }
    
    func showErrorMsg(msg: String) {
        
    }
    
    func backLoginPage(msg: String) {
        
    }
    
    
}
extension BankAccountsVC: EditDelegate {
    func openViewController(model: TotalBankAccounts) {
        let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "EditBankVC") as! EditBankVC
        vc.editModel = model
//        vc.navigation = self.navigationController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}
