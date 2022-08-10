//
//  HomeView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI
import Alamofire
import SwiftyJSON

public struct homeDatas: Decodable {
    let lastBuildDate: String
    let display: Int
    let start: Int
    let total: Int
    let items: [homeItems]
}

public struct homeItems: Decodable {
    let pubDate: String
    let description: String
    let link: String
    let title: String
    let originallink: String
}

struct HomeView: View {
    let decoder: JSONDecoder = JSONDecoder()
    @State var homeList = [homeItems]()
    func replacer(_ str: String) -> String {
        var result = str
        for i in ["</b>", "<b>", "&apos;", "&quot;"] {
            result = result.replacingOccurrences(of: i, with: "")
        }
        return result
    }
    var body: some View {
        List {
            ForEach(0..<homeList.count, id: \.self) { idx in
                VStack(alignment: .leading) {
                    Text(replacer(homeList[idx].title))
                        .font(.title2)
                        .bold()
                    Text(replacer(homeList[idx].description))
                    Text(homeList[idx].pubDate)
                        .font(.footnote)
                }
            }
        }
            .onAppear {
                AF.request("https://openapi.naver.com/v1/search/news.json?query=%EC%95%8C%EB%A0%88%EB%A5%B4%EA%B8%B0&sort=sim&display=100", method: .get, encoding: URLEncoding.default, headers: ["X-Naver-Client-Id": "yQdhR2jeN0fZpRDFbSwM", "X-Naver-Client-Secret": "9d_lsGNnaD"]).responseData {
                    guard let value = $0.value else { return }
                    guard let result = try? decoder.decode(homeDatas.self, from: value) else { return }
                    self.homeList = result.items
                }
            }
            .navigationTitle("홈")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
