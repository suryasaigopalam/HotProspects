//
//  ContentView.swift
//  HotProspects
//
//  Created by surya sai on 08/06/24.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    @State var backGround = Color.red
    var body: some View {
        TabView {
            ProspectsView(filterType: .none)
                .tabItem {
                    Label("Everyone", systemImage:"person.3")
                }
            
            ProspectsView(filterType: .contacted)
                    .tabItem {
                        Label("Contacted", systemImage:"checkmark.circle")
                    }
            ProspectsView(filterType: .uncontacted)
                    .tabItem {
                        Label("Uncontacted", systemImage:"questionmark.diamond")
                    }
            
            MeView()
                .tabItem {
                    Label("Me",systemImage: "person.crop.square")
                }
        
        }
        
    }
}

#Preview {
    ContentView()
}
