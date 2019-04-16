//
//  MerchantsResponseModel.swift
//  AppWhereTest
//
//  Created by Yoshi Revelo on 4/14/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import Foundation

class MerchantsResponseModel: Codable{
    
    var status = 0
    var description = ""
    var merchants: [Merchant]
}
