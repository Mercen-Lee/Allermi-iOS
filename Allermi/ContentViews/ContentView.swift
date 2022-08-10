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

struct ColorManager {
    static let LightColor = Color("LightColor")
}

struct ContentView: View {
    @State var selectedIndex = 2
    let icons = ["house.fill", "bubble.left.and.bubble.right.fill", "magnifyingglass", "heart.text.square.fill", "person.fill"]
    let names = ["홈", "소통", "", "상태", "프로필"]
    var body: some View {
        ZStack {
            ZStack {
                Spacer()
                switch selectedIndex {
                    case 0: HomeView()
                    case 1: CommunityView()
                    case 2: SearchView()
                        .padding(.bottom, scs/5)
                    case 3: HealthView()
                    default: ProfileView()
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                
                HStack {
                    ForEach(0..<5, id: \.self) { idx in
                        Spacer()
                        Button(action: { self.selectedIndex = idx }, label: {
                            if idx == 2 { Image(systemName: icons[idx])
                                    .font(
                                        .system(size: scs/25, weight: .regular, design: .default))
                                    .foregroundColor(
                                        Color(.systemBackground))
                                    .frame(width: scs/12, height: scs/12)
                                    .background(
                                        selectedIndex == idx ? Color.accentColor : .gray)
                                    .cornerRadius(scs/10)
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
        .navigationBarHidden(false)
        .navigationTitle("")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
