//
//  NetworkDaemon.swift
//  FDTables
//
//  Created by Academia on 2/18/20.
//  Copyright © 2020 Cate. All rights reserved.
//

import Foundation

class NetworkDaemon: ObservableObject {
    @Published var people = [Person]()
    @Published var tables = [Table]()
    
    init() { // Upon initialization:
        load()
    }
    
    func load() {
        let urlP = URL(string: "https://a-better-concierge-for-dinner-server.jacobwucate.repl.co/people")!
        URLSession.shared.dataTask(with: urlP) { (data,response,error) in // Establish connection to specified URL
            do {
                if let d = data {
                    let decodedLists = try JSONDecoder().decode([Person].self, from: d) // Try to decode JSON
                    DispatchQueue.main.async {
                        self.people = decodedLists // Store decoded JSON as self.people
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print ("Error")
            }
        }.resume()
        
        let urlT = URL(string: "https://a-better-concierge-for-dinner-server.jacobwucate.repl.co/tables")!
        URLSession.shared.dataTask(with: urlT) { (data,response,error) in // Establish connection to specified URL
            do {
                if let d = data {
                    let decodedTables = try JSONDecoder().decode([Table].self, from: d) // Try to decode JSON
                    DispatchQueue.main.async {
                        self.tables = decodedTables.sorted{$0.id < $1.id} // Store decoded JSON as self.tables
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print ("Error", error)
            }
        }.resume()
//        tables = tables.sorted($0.id < $1.id)
    }
}
