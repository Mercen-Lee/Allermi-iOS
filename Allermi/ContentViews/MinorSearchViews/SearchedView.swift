//
//  SearchedView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/18.
//44

import SwiftUI

struct SearchedView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var text: String
    var body: some View {
        List {
            Section(header: Text("검색 결과")) {
                Text("dd")
                    .listRowBackground(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle(text)
        .onAppear {
            UITableView.appearance().backgroundColor = .systemBackground
        }
    }
}

struct SearchedView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedView(text: "text")
    }
}
