//
//  BankHeaderView.swift
//  batuaa
//
//  Created by Trilok Patel on 06/08/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class BankHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var bankName: UILabel!
    
    @IBOutlet weak var disclosureName: UIImageView!
}
