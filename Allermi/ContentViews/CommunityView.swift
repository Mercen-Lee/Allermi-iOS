//
//  CommunityView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        List {
            HStack {
                Text("Nickname")
            }
        }
        .navigationTitle("소통")
        .refreshable { }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
