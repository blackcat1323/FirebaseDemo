//
//  Item.swift
//  FirebaseDemo
//
//  Created by admin on 3/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Item {
    let ref : FIRDatabaseReference?
    var title : String?
    
    init(snapShot: FIRDataSnapshot) {
        ref = snapShot.ref
        let value = snapShot.value as! Dictionary<String,String>
        title = value["title"]
    }
}
