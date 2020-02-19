//
//  ContentView.swift
//  FDTables
//
//  Created by Academia on 2/17/20.
//  Copyright © 2020 Cate. All rights reserved.
//

import SwiftUI

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

struct ContentView: View { // Main window
    //MARK: - Properties
    @State var selectedView: Int = 2 // Controls which view is displayed
    @State var showingDetail = false // Controls whether a popup view is displayed
    @State var searchText: String = ""
    @State var showCancelButton: Bool = true
    
    //MARK: - Objects
    @ObservedObject var networkDaemon = NetworkDaemon()
    
    //MARK: - Screen
    var body: some View {
        TabView(selection: $selectedView) {
            //MARK: Tables View
            NavigationView {
                VStack {
                    List {
                        ForEach((1...31), id: \.self) { tableNo in
                            HStack {
                                Button(action: {
                                    self.showingDetail.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "\(tableNo).circle.fill")
                                        Text("Table \(tableNo)")
                                    }
                                }.sheet(isPresented: self.$showingDetail) {
                                    DetailTableView(tableNo: tableNo, people: self.networkDaemon.people)
                                }
                            }
                        }
                    }
                }.navigationBarTitle(Text("🍽 Tables"))
            }.tabItem {
                Image(systemName: "house.fill")
                Text("Table")
            }.tag(1)
            
            //MARK: People View
            NavigationView {
                VStack {
                    List {
                        ForEach(networkDaemon.people, id: \.self) { person in
//                            Text(person.name)
                            Button(action: {
                                self.showingDetail.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "\(person.name.prefix(1).lowercased()).square.fill")
                                    Text(person.name)
                                }
                            }.sheet(isPresented: self.$showingDetail) {
                                DetailPersonView(withInfo: person)
                            }
                        }.navigationBarTitle(Text("👥 People"))
                    }
                }
            }.tabItem {
                Image(systemName: "person.fill")
                Text("People")
            }.tag(2)
            
            //MARK: Search View
            NavigationView {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("search", text: $searchText, onEditingChanged: { isEditing in
                                self.showCancelButton = true
                            }, onCommit: {
                                print("onCommit")
                            }).foregroundColor(.primary)
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                            }
                        } // Search Bar
                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10.0)
                        if showCancelButton {
                            Button("Cancel") {
                                UIApplication.shared.endEditing()
                                self.searchText = ""
                                self.showCancelButton = false
                            }
                            .foregroundColor(Color(.systemBlue))
                        }
                    } // Search Bar + Cancel Button
                    .padding(.horizontal)
                        .navigationBarHidden(true)
                    List {
                        ForEach(networkDaemon.people.filter{$0.name.hasPrefix(searchText) || searchText == ""}, id:\.self) { person in
                            Button(action: {
                                self.showingDetail.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "\(person.name.prefix(1).lowercased()).square.fill")
                                    Text(person.name)
                                }
                            }.sheet(isPresented: self.$showingDetail) {
                                DetailPersonView(withInfo: person)
                            }
                        }.navigationBarTitle(Text("🔍 Search"))
                    } // Filtered list of names
                } // THIS SECTION INCLUDES SUBSTANTIAL REFERENCE TO STACKOVERFLOW-SEARCH BAR-SWITFTUI
            }.tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailTableView: View { // Popup table information
    @Environment(\.presentationMode) var presentationMode
    var tableNo: Int
    var people: [Person]
    var body: some View {
        ZStack{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {Color(.clear)} // Click any white space to dismiss sheet
            VStack{
                Text("Table \(tableNo)").font(.largeTitle)
                ForEach(people.filter{$0.currentAssignment == "Table \(tableNo)"}, id: \.self) { person in
                    Text(person.name)
                }
            }
        }
    }
}

struct DetailPersonView: View { // Popup person information
    @Environment(\.presentationMode) var presentationMode
    var withInfo: Person
    var body: some View {
        ZStack{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {Color(.clear)} // Click any white space to dismiss sheet
            VStack{
                Text(withInfo.name).font(.largeTitle)
                Text("ID: \(withInfo.id) | Served \(withInfo.timesServed) times").font(.caption)
                Text("Previous Assignments: \(withInfo.previousAssignments.joined(separator: ","))").font(.caption)
                Spacer()
                Text("Current Assignment: \(withInfo.currentAssignment)").font(.title)
                Spacer()
            }.padding(.top, 100)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/* Sources
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-new-view-using-sheets
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-make-a-view-dismiss-itself
 https://stackoverflow.com/questions/56677633/swiftui-scrollview-only-scroll-in-one-direction
 https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui
 https://medium.com/@rbreve/displaying-a-list-with-swiftui-from-a-remote-json-file-6b4e4280a076
 https://stackoverflow.com/questions/31003977/how-can-i-convert-an-int-array-into-a-string-array-in-swift/31004201
 https://stackoverflow.com/questions/25827033/how-do-i-convert-a-swift-array-to-a-string
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-respond-to-view-lifecycle-events-onappear-and-ondisappear
 */
