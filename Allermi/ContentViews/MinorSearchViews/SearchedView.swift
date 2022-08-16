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
    let number: String
    let nutrient: String
    let type: String
}

struct UserInfo: Decodable {
    let allergy: [String]
    let id: Int
    let password: String
    let refreshToken: String
    let roles: [String]
    let userid: String
}

struct SearchedView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var searchKeyword: String
    @State var searchResult = [SearchedData]()
    @State var userAllergy = [String]()
    func load() {
        AF.request("\(api)/item/search", method: .get, parameters: ["keyword": searchKeyword], encoding: URLEncoding.default, headers: ["Content-Type": "application/json"])
                .responseData { response in
                    guard let value = response.value else { return }
                    guard let result = try? decoder.decode([SearchedData].self, from: value) else { return }
                    self.searchResult = result
                }
    }
    func loadMyInfo() {
        AF.request("\(api)/sign", method: .get, encoding: URLEncoding.default, headers: ["ACCESS_TOKEN": UserDefaults.standard.string(forKey: "token")!, "Content-Type": "application/json"])
            .responseData { response in
                //print(String(decoding: response.data!, as: UTF8.self))
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(UserInfo.self, from: value) else { return }
                self.userAllergy = result.allergy
        }
    }
    func checkDuplicated(_ arr: String) -> [String] {
        var result = [String]()
        for i in userAllergy {
            for j in arr.components(separatedBy: ",") {
                if i == j {
                    result.append(i)
                }
            }
        }
        return result
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
                        Text(checkDuplicated(searchResult[idx].allergy).isEmpty ? "알레르기 해당 없음" : "\(checkDuplicated(searchResult[idx].allergy).joined(separator: ", ")) 일치")
                            .fontWeight(checkDuplicated(searchResult[idx].allergy).isEmpty ? .regular : .bold)
                    }
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 10)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .background(checkDuplicated(searchResult[idx].allergy).isEmpty ? Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9) : .accentColor.opacity(0.5))
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 10)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(searchKeyword)
        .onAppear {
            load()
            loadMyInfo()
        }
        .refreshable {
            load()
            loadMyInfo()
        }
    }
}

struct SearchedDetailView: View {
    @Binding var data: SearchedData
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: data.metaURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
            } placeholder: { ProgressView() }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .bottom, spacing: 3) {
                    Text(data.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(data.type)
                        .font(.subheadline)
                }
                Text(data.allergy)
                Text(data.ingredient)
                    .font(.caption)
            }
            .padding(20)
            Spacer()
        }
        .ignoresSafeArea()
    }
}

//struct SearchedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchedDetailView()
//    }
//}
