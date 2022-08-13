//
//  CommunityView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

struct CommunityDatas: Decodable {
    let id: Int
    let author: String
    let body: String
    let image: String
    let likes: Int
    let date: String
}

let dummyData: [CommunityDatas] = [
    CommunityDatas(id: 1, author: "mercen", body: "hello", image: "https://nater.com/nater_riding.jpg", likes: 1, date: "2022년 8월 7일"),
    CommunityDatas(id: 2, author: "HINU", body: "chingthao", image: "https://nater.com/nater_riding.jpg", likes: 1, date: "2022년 8월 7일")
]

struct CommunityView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        List {
            ForEach(0..<dummyData.count, id: \.self) { idx in
                VStack(alignment: .leading) {
                    Text(dummyData[idx].author)
                    Text(dummyData[idx].body)
                    AsyncImage(url: URL(string: dummyData[idx].image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .padding(20)
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
            .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
            .listRowInsets(EdgeInsets())
            .padding(.bottom, 10)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("소통")
        .navigationBarItems(trailing: Button(action: {
            
        }) {
            Image(systemName: "plus")
                .foregroundColor(.accentColor)
        })
        .refreshable { }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
