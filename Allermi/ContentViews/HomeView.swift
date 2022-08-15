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
    var items: [homeItems]
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
    @State var selectedURL = String()
    @State var homeList = [homeItems]()
    @State var pickerSelection = 0
    func replacer(_ str: String) -> String {
        var result = str
        for i in ["</b>", "<b>", "&apos;", "&quot;"] {
            result = result.replacingOccurrences(of: i, with: "")
        }
        return result
    }
    func load(_ start: Int) {
        AF.request("https://openapi.naver.com/v1/search/news.json?query=%EC%95%8C%EB%A0%88%EB%A5%B4%EA%B8%B0&sort=\(pickerSelection == 0 ? "sim" : "date")&display=100&start=\(start)", method: .get, encoding: URLEncoding.default, headers: ["X-Naver-Client-Id": "yQdhR2jeN0fZpRDFbSwM", "X-Naver-Client-Secret": "9d_lsGNnaD"]).responseData {
            guard let value = $0.value else { return }
            guard let result = try? decoder.decode(homeDatas.self, from: value) else { return }
            var fres = result.items
            for i in 0..<fres.count {
                if fres.count <= i { break }
                for j in i+1..<fres.count {
                    if fres.count <= j { break }
                    if cluster(fres[i].title, fres[j].title) > 10000 {
                        print(j)
                        fres.remove(at: j)
                    }
                }
            }
            self.homeList = fres
        }
    }
    let decoder: JSONDecoder = JSONDecoder()
    func timeParse(_ original: String) -> String {
        let x = original.components(separatedBy: " ")
        return "\(x[3])년 \(["Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12][x[2]]!)월 \(x[1])일 \(["Mon,": "월", "Tue,": "화", "Wed,": "수", "Thu,": "목", "Fri,": "금", "Sat,": "토", "Sun,": "일"][x[0]]!)요일"
    }
    func cluster(_ str1: String, _ str2: String) -> Int {
        let str1Arr = Array(str1)
        let str2Arr = Array(str2)
        
        var str1arr: [String] = []
        var str2arr: [String] = []

        for i in 0..<str1Arr.count - 1 {
            if str1Arr[i].isLetter && str1Arr[i+1].isLetter{
                str1arr.append("\(str1Arr[i].uppercased())\(str1Arr[i+1].uppercased())")
            }
        }

        for i in 0..<str2Arr.count - 1 {
            if str2Arr[i].isLetter && str2Arr[i+1].isLetter{
                str2arr.append("\(str2Arr[i].uppercased())\(str2Arr[i+1].uppercased())")
            }
        }
        
        var allCnt =  str1arr.count + str2arr.count
        var myCnt = 0

        for i in str1arr.indices{
            for j in str2arr.indices{
                if str1arr[i] == str2arr[j]{
                    myCnt += 1
                    str2arr.remove(at: j)
                    break
                }
            }
        }

        allCnt -= myCnt
        
        if allCnt == 0{
            return 65536
        }
        else if myCnt == 0{
            return 0
        }
        else{
            return Int(Double(myCnt) / Double(allCnt) * 65536)
        }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<homeList.count, id: \.self) { idx in
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
                                                .foregroundColor(Color(.label))
                                                .padding(2)
                                                .frame(width: 30, height: 30)
                                    }
                                }
                                Text(replacer(homeList[idx].description))
                                    .font(.caption)
                                HStack {
                                    Spacer()
                                    Text(timeParse(homeList[idx].pubDate))
                                        .font(.caption2)
                                        .opacity(0.5)
                                }
                            }
                            Spacer()
                        }
                        .padding([.top, .bottom, .trailing], 10)
                        .padding(.leading, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                    .listRowInsets(EdgeInsets())
                    .background(NavigationLink("", destination: ExtendedHomeView(path: homeList[idx].originallink)).opacity(0))
                    .padding(.bottom, homeList.count == idx + 1 ? 100 : 20)
                }
            }
            .overlay(Group {
                if homeList.isEmpty {
                    ProgressView()
                        .padding(.bottom, scs/5)
                }
            })
            .listStyle(PlainListStyle())
            .refreshable {
                load(1)
            }
            .onAppear {
                load(1)
            }
            .navigationTitle("홈")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker(selection: $pickerSelection, label: Text("Sorting options")) {
                            Text("연관도순").tag(0)
                            Text("최신순").tag(1)
                        }
                        .onChange(of: pickerSelection) { tag in load(1) }
                    }
                    label: {
                        Label("Sort", systemImage: pickerSelection == 0 ? "list.dash" : "calendar")
                    }
                }
            }
        }
    }
}

struct ExtendedHomeView: UIViewRepresentable {
    @State var path: String
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: path) else { return }
        uiView.load(.init(url: url))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
