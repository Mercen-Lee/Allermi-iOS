//
//  ProfileView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var lists = ["a", "b", "c", "d"]
    var body: some View {
        List {
            ForEach(0..<lists.count, id: \.self) { idx in
                Text(lists[idx])
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, lists.count == idx + 1 ? 100 : 20)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
