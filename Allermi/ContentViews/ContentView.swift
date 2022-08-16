//
//  ContentVIew.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

public let scs = UIScreen.main.bounds.size.height
public let scw = UIScreen.main.bounds.size.width

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove { self.hidden() }
        } else { self }
    }
}

struct ContentView: View {
    @State var logout = false
    @State var selectedIndex = 2
    let icons = ["house.fill", "bubble.left.and.bubble.right.fill", "magnifyingglass", "heart.text.square.fill", "person.fill"]
    let names = ["홈", "소통", "", "상태", "프로필"]
    init() {
        UITableView.appearance().backgroundColor = .systemBackground
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: FirstView(), isActive: $logout) { EmptyView() }
                ZStack {
                    Spacer()
                    switch selectedIndex {
                        case 0: HomeView()
                        case 1: CommunityView()
                        case 2: SearchView()
                            .padding(.bottom, scs < 800 ? scs/10 : scs/12)
                        case 3: HealthView()
                        default: ProfileView(logout: $logout)
                    }
                }
                VStack(spacing: 0) {
                    Spacer()
                    Divider()
                    HStack {
                        ForEach(0..<5, id: \.self) { idx in
                            Spacer()
                            Button(action: { self.selectedIndex = idx }, label: {
                                if idx == 2 {
                                    Image("SearchButton")
                                        .resizable()
                                        .antialiased(true)
                                        .renderingMode(.template)
                                        .foregroundColor(selectedIndex == idx ? Color.accentColor : .gray)
                                        .frame(width: scs/12, height: scs/12)
                                }
                                else {
                                    VStack {
                                        Image(systemName: icons[idx])
                                            .font(.system(size: idx == 0 ? scs/25 : idx == 1 ? scs/30 : scs/23, weight: .regular, design: .default))
                                        .frame(width: scs/25, height: scs/25)
                                        .foregroundColor(selectedIndex == idx ? .accentColor : .gray)
                                        Text(names[idx])
                                            .foregroundColor(selectedIndex == idx ? .accentColor : .gray).font(.system(size: 10, weight: .bold, design: .default))
                                    }
                                }
                            })
                            Spacer()
                        }
                    }
                    .padding(EdgeInsets(
                        top: scs < 800 ? 5 : 10,
                        leading: scs/100,
                        bottom: scs < 800 ? 5 : 30,
                        trailing: scs/100))
                    .background(.regularMaterial)
                }
                .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
