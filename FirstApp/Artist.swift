//
//  Artist.swift
//  FirstApp
//
//  Created by Navid Zaman on 4/28/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import Foundation
import UIKit

struct Artist : Decodable {
    var artist : String
    
    init(name : String){
        self.artist = name
    }
}


