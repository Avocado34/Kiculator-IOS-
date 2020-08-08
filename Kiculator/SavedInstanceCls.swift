//
//  File.swift
//  Kiculator
//
//  Created by 이승기 on 2020/08/01.
//  Copyright © 2020 이승기. All rights reserved.
//

import RealmSwift

class SavedInstanceCls: Object{
    @objc dynamic var appName: String = ""
    @objc dynamic var baseFee: String = ""
    @objc dynamic var feePerMin: String = ""
    @objc dynamic var baseMin: String = ""

}
