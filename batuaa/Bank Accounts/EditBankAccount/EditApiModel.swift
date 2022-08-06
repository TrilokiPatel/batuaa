//
//  EditApiModel.swift
//  batuaa
//
//  Created by Trilok Patel on 10/12/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
struct EditApiModel : Codable {
    let status : String?
    let sub_status : String?
    let msg : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case sub_status = "sub_status"
        case msg = "msg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        sub_status = try values.decodeIfPresent(String.self, forKey: .sub_status)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
       // data = try values.decodeIfPresent(Data.self, forKey: .data)
    }

}
