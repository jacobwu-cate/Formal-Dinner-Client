//
//  TableStruct.swift
//  FDTables
//
//  Created by Academia on 2/19/20.
//  Copyright © 2020 Cate. All rights reserved.
//

import Foundation

struct Table: Decodable, Hashable, Identifiable {
    public var id: Int
    public var occupants: [Person]
//    public var disallow: [Int]
    enum CodingKeys: String, CodingKey {
       case id = "Id"
       case occupants = "Occupants"
//       case disallow = "Disallow"
    }
}
