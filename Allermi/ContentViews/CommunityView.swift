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
    let liked: Bool
    let date: String
}

let dummyData: [CommunityDatas] = [
    CommunityDatas(id: 1, author: "jjjombi", body: "안뇽~", image: "https://herb-api.hankookilbo.com/api/attaches/image/group/3afb106a-5b5f-466e-8c8d-e1f7be42495c", likes: 20, liked: true, date: "2022년 8월 7일"),
    CommunityDatas(id: 2, author: "HINU", body: "양꼬치엔 칭따오", image: "http://kor.theasian.asia/wp-content/uploads/2020/06/%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C-2020-06-05T084841.330.jpg", likes: 0, liked: false, date: "2022년 8월 7일")
]

struct CommunityView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        List {
            ForEach(0..<dummyData.count, id: \.self) { idx in
                VStack(alignment: .leading) {
                    HStack {
                        Text(dummyData[idx].author)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(dummyData[idx].likes)")
                        Button(action: {
                            
                        }) {
                        Image(systemName: dummyData[idx].liked ? "heart.fill" : "heart")
                            .foregroundColor(dummyData[idx].liked ? .accentColor : Color(.label))
                            .font(.title2)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("InvertedGrayColor").opacity(colorScheme == .dark ? 0.05 : 0.1))
                    Text(dummyData[idx].body)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.leading, .trailing], 20)
                    VStack(alignment: .trailing) {
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
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                        }
                        Text(dummyData[idx].date)
                            .font(.caption2)
                            .opacity(0.5)
                    }
                    .padding([.leading, .trailing, .bottom], 20)
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                .listRowInsets(EdgeInsets())
                .padding(.bottom, dummyData.count == idx + 1 ? 100 : 20)
            }
        }
        .buttonStyle(PlainButtonStyle())
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
        CommunityView()//.preferredColorScheme(.dark)
    }
}
