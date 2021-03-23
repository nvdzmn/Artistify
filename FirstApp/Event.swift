//
//  Event.swift
//  FirstApp
//
//  Created by Navid Zaman on 4/16/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import Foundation
import UIKit

struct Event : Decodable{
    var offers: [Offer]
    var venue : EventVenue
    var datetime : String
    var artist : EventArtist
    var description : String
    var id : String
    var title : String
}
