//
//  ActivityTableCell.swift
//  batuaa
//
//  Created by Trilok Patel on 18/09/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class ActivityTableCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var ipLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupDataFromModel(model: ActivityData) {
        self.dateLbl.text = Helper.app.dateTimeformatConverter(model.createdDate ?? "")
        
//        self.ipLbl.text = model.ip
        self.activityLbl.text = (model.operation?.replacingOccurrences(of: "_", with: " ", options: NSString.CompareOptions.literal, range:nil))?.capitalized
       // self.activityLbl.text = model.operation
    }

}
