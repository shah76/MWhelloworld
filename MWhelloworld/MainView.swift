//
//  ContentView.swift
//  MWhelloworld
//
//  Created by haroon shah on 1/15/26.
//

import MWDATCore
import SwiftUI

struct MainView: View {
    let wearables: WearablesInterface
    @ObservedObject private var viewModel: WearablesViewModel
    
    init(wearables: WearablesInterface, viewModel: WearablesViewModel) {
        self.wearables = wearables
        self.viewModel = viewModel
    }
    var body: some View {
        let _ = Self._logChanges()
        let _ = Self._printChanges()
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                NavigationLink("detail", destination: DetailView())
            }
            .navigationTitle(Text("Hello, world!"))
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

