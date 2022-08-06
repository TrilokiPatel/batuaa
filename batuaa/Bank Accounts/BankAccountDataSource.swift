//
//  BankAccountDataSource.swift
//  batuaa
//
//  Created by Trilok Patel on 26/11/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
import UIKit

protocol EditDelegate {
    func openViewController(model: TotalBankAccounts)
}

class BankAccountDataSource: NSObject, UITableViewDataSource {
    
    var viewM: BankAccountViewModel?
    var delegate: EditDelegate?
    var navigation: UINavigationController?
    var tableView: UITableView?
   // var sectionNames: [String] = []
    
    
    let kHeaderSectionTag: Int = 6900
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
   // var sectionItems = [[VirtualBankAccountData]]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewM?.sectionNames.count ?? 0 > 0 {
            return (viewM?.sectionNames.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            
            return 1
        } else {
            return 0;
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (self.sectionNames.count != 0) {
//            return self.sectionNames[section]
//        }
//        return ""
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 149.0
    }
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0;
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    

    internal func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                            withIdentifier: BankHeaderView.reuseIdentifier)
                            as? BankHeaderView
        else {
            return nil
        }
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor(hexString: "#EEEEEE")
        view.backgroundView = backgroundView
        view.bankName?.text = viewM?.sectionNames[section]
        view.bankName?.textColor = UIColor(hexString: "#222222")
        view.disclosureName.tag = kHeaderSectionTag + section
        
        let headerTapGesture = UITapGestureRecognizer()
                    headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
                    view.addGestureRecognizer(headerTapGesture)
        view.tag = section

        return view
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "BankTableCell", for: indexPath) as! BankTableCell
        let section = viewM?.sectionItems[indexPath.section]
        cell.setupDataFromModel(model: section!, bankDetail: (viewM?.bankAccountsDetail)!)
        cell.btnEdit.addTarget(self, action: #selector(editButton(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.section
        
        return cell
    }
    @objc func editButton(_ sender: UIButton) {
        self.delegate?.openViewController(model: (viewM?.sectionItems[sender.tag])!)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
       
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.tableView?.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.viewM?.sectionItems
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData?.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (360.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for _ in 0 ..< sectionData!.count {
                let index = IndexPath(row: 0, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.viewM?.sectionItems
    
        if (sectionData!.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (90.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for _ in 0 ..< sectionData!.count {
                let index = IndexPath(row: 0, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    
    
}
extension BankAccountDataSource: UITableViewDelegate {
    convenience init(viewModel: BankAccountViewModel,navigation: UINavigationController, tableView: UITableView, delegate: EditDelegate) {
        self.init()
        viewM = viewModel
        self.tableView = tableView
        self.navigation =  navigation
        self.delegate = delegate
    }
    
    
}
