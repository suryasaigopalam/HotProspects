//
//  ProspectsView.swift
//  HotProspects
//
//  Created by surya sai on 10/06/24.
//

import SwiftUI
import SwiftData
import CodeScanner

struct ProspectsView: View {
    enum FilterType {
        case none,contacted,uncontacted
    }
    
    
    @Environment(\.modelContext) var modelContext
    @State var isShowingScanner = false
    @Query var prospects:[Prospect]
    
    @State var selectedProspects = Set<Prospect>()
    
    let filterType:FilterType
    
    var title:String {
        switch filterType {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    
    var body: some View {
        NavigationStack  {
            List(prospects,selection: $selectedProspects) { prospect in
                VStack(alignment:.leading) {
                    
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                    }
                }
                .tag(prospect)
                
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner, content: {
                
                
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            })
            
        }
    }
    
    init(filterType:FilterType) {
        self.filterType = filterType
        if filterType != .none {
            let contacted = filterType == .contacted
            
            _prospects = Query(filter: #Predicate {
                $0.isContacted == contacted
                
            }, sort: [SortDescriptor<Prospect>(\.name, order: .forward)])
            
            
        }
        
    }
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)

            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
}

#Preview {
    ProspectsView(filterType: .none)
        .modelContainer(for:Prospect.self)
}
