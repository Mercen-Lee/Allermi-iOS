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
            HStack {
                AsyncImage(url: URL(string: "http://fresh.haccp.or.kr/prdimg/1992/19920562023315/19920562023315-1.jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipped()
                } placeholder: { ProgressView() }
                    .frame(width: 80, height: 80)
                VStack(alignment: .leading) {
                    Text("코코팜 포도맛")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("알레르기 해당 없음")
                }
                .padding(.leading, 5)
            }
            .listRowBackground(colorScheme == .dark ? Color(.gray).opacity(0.3) : Color(.gray).opacity(0.1))
        }
        .listStyle(PlainListStyle())
        .navigationTitle(text)
        .onAppear {
            UITableView.appearance().backgroundColor = .systemBackground
        }
        .refreshable {
            
        }
    }
}

struct SearchedView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedView(text: "text")
    }
}
