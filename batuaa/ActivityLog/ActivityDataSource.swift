//
//  ActivityDataSource.swift
//  batuaa
//
//  Created by Trilok Patel on 18/09/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
import UIKit

class ActivityDataSource: NSObject, UITableViewDataSource {
    
    var viewM: ActivityViewModel?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((viewM?.activityItem.count)!)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableCell", for: indexPath) as! ActivityTableCell
        cell.setupDataFromModel(model: viewM!.activityItem[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension ActivityDataSource: UITableViewDelegate {
    convenience init(viewModel: ActivityViewModel) {
        self.init()
        viewM = viewModel
    }
}
