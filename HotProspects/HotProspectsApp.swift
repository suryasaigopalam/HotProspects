//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by surya sai on 08/06/24.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:Prospect.self)
        
    }
}
