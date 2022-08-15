//
//  SearchedView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/18.
//

import SwiftUI
import Alamofire

struct SearchedData: Decodable {
    let allergy: String
    let company: String
    let imageURL: String
    let ingredient: String
    let metaURL: String
    let name: String
    let number: Int
    let nutrient: String
    let type: String
}

struct SearchedView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var searchKeyword: String
    @State var searchResult = [SearchedData]()
    func load() {
        AF.request("\(api)/item/search", method: .get, parameters: ["keyword": searchKeyword], encoding: URLEncoding.default, headers: ["Content-Type": "application/json", "ACCESS_TOKEN": UserDefaults.standard.string(forKey: "token")!])
                .responseData { response in
                    print(String(decoding: response.data!, as: UTF8.self))
                    guard let value = response.value else { return }
                    guard let result = try? decoder.decode([SearchedData].self, from: value) else { return }
                    self.searchResult = result
                }
    }
    let decoder: JSONDecoder = JSONDecoder()
    var body: some View {
        List {
            ForEach(0..<searchResult.count, id: \.self) { idx in
                HStack {
                    AsyncImage(url: URL(string: searchResult[idx].imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .clipped()
                    } placeholder: { ProgressView() }
                        .frame(width: 60, height: 60)
                        .padding(.trailing, 10)
                    VStack(alignment: .leading) {
                        Text(searchResult[idx].name)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                        Text("알레르기 해당 없음")
                    }
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 10)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(searchKeyword)
        .onAppear {
            load()
        }
        .refreshable {
            load()
        }
    }
}

struct SearchedView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedView(searchKeyword: "text")
    }
}
