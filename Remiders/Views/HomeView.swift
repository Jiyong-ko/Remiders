//
//  HomeView.swift
//  Remiders
//
//  Created by Noel Mac on 2/3/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: ContentView()) {
                    Label("미리 알림", systemImage: "list.bullet.rectangle.portrait")
                        .font(.title2)
                }
            }
            .navigationTitle("목록")
        }
    }
}

#Preview {
    HomeView()
}
