//
//  HomeView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import LinkPresentation
import WebKit

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
    @Environment(\.colorScheme) var colorScheme
    let decoder: JSONDecoder = JSONDecoder()
    @State var homeList = [homeItems]()
    @State var extendedView = false
    @State var selectedURL = String()
    func replacer(_ str: String) -> String {
        var result = str
        for i in ["</b>", "<b>", "&apos;", "&quot;"] {
            result = result.replacingOccurrences(of: i, with: "")
        }
        return result
    }
    func load(_ start: Int) {
        AF.request("https://openapi.naver.com/v1/search/news.json?query=%EC%95%8C%EB%A0%88%EB%A5%B4%EA%B8%B0&sort=sim&display=100&start=\(start)", method: .get, encoding: URLEncoding.default, headers: ["X-Naver-Client-Id": "yQdhR2jeN0fZpRDFbSwM", "X-Naver-Client-Secret": "9d_lsGNnaD"]).responseData {
            guard let value = $0.value else { return }
            guard let result = try? decoder.decode(homeDatas.self, from: value) else { return }
            self.homeList = result.items
        }
    }
    var body: some View {
        List {
            ForEach(0..<homeList.count, id: \.self) { idx in
                Button(action: {
                    selectedURL = homeList[idx].originallink
                    extendedView = true
                }) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack(alignment: .top) {
                                    Text(replacer(homeList[idx].title))
                                        .font(.title2)
                                        .bold()
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                    AsyncImage(url: URL(string: "https://\(homeList[idx].originallink.components(separatedBy: "/")[2])/favicon.ico")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 30, height: 30)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .clipped()
                                        } placeholder: {
                                            Image(systemName: "newspaper.fill")
                                                .resizable()
                                                .foregroundColor(Color("LightColor"))
                                                .padding(2)
                                                .frame(width: 30, height: 30)
                                    }
                                }
                                Text(replacer(homeList[idx].description))
                                    .font(.caption)
                                HStack {
                                    Spacer()
                                    Text(homeList[idx].pubDate)
                                        .font(.caption2)
                                        .opacity(0.5)
                                }
                            }
                            Spacer()
                        }
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 20)
                    }
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $extendedView) {
            ExtendedHomeView(path: self.selectedURL)
        }
        .listStyle(PlainListStyle())
        .refreshable {
            load(1)
        }
        .onAppear {
            load(1)
        }
        .navigationTitle("홈")
    }
}

struct ExtendedHomeView: UIViewRepresentable {
    @State var path: String
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) {

        guard let url = URL(string: path) else { return }

        uiView.scrollView.isScrollEnabled = false
        uiView.load(.init(url: url))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
