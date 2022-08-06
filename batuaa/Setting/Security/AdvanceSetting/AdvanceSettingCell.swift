//
//  AdvanceSettingCell.swift
//  batuaa
//
//  Created by Trilok Patel on 09/12/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class AdvanceSettingCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupDataFromModel(model: String) {
        nameLbl.text = model
    }
}
