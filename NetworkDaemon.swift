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
    
    init() {
        load()
    }
    func load() {
//        let session = URLSession.shared
//        let url = URL(string: "https://a-better-concierge-for-dinner-server.jacobwucate.repl.co")!
//        let task = session.dataTask(with: url) { (data, _, _) -> Void in
//            if let data = data {
//                let string = String(data: data, encoding: String.Encoding.utf8)
//                print(string) //JSONSerialization
//            }
//        }
//        task.resume()
        let url = URL(string: "https://a-better-concierge-for-dinner-server.jacobwucate.repl.co")!
        URLSession.shared.dataTask(with: url) {(data,response,error) in
            do {
                if let d = data {
                    let decodedLists = try JSONDecoder().decode([Person].self, from: d)
                    DispatchQueue.main.async {
                        self.people = decodedLists
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print ("Error")
            }
            
        }.resume()
    }
}
