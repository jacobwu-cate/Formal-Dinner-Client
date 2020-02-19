//
//  PersonStruct.swift
//  FDTables
//
//  Created by Academia on 2/19/20.
//  Copyright © 2020 Cate. All rights reserved.
//

import Foundation

struct Person: Decodable, Hashable, Identifiable {
    public var name: String
    public var id: Int
    public var timesServed: Int
    public var haveMet: [Int]
    public var previousAssignments: [String]
    public var currentAssignment: String
    enum CodingKeys: String, CodingKey {
       case name = "Name"
       case id = "Id"
       case timesServed = "TimesServed"
       case haveMet = "HaveMet"
       case previousAssignments = "PreviousAssignments"
       case currentAssignment = "CurrentAssignment"
    }
}
