//
//  ContentVIew.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

public let scs = UIScreen.main.bounds.size.height
public let scw = UIScreen.main.bounds.size.width

struct ColorManager {
    static let LightColor = Color("LightColor")
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedIndex = 2
    let icons = ["house.fill", "bubble.left.and.bubble.right.fill", "magnifyingglass", "heart.text.square.fill", "person.fill"]
    let names = ["홈", "커뮤니티", "", "상태", "프로필"]
    var body: some View {
        ZStack {
            ZStack {
                Spacer()
                switch selectedIndex {
                    case 0: HomeView()
                    case 1: CommunityView()
                    case 2: SearchView()
                    case 3: HealthView()
                    default: ProfileView()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: scs/15, trailing: 0))
            
            VStack(spacing: 0) {
                
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                
                HStack {
                    ForEach(0..<5, id: \.self) { number in
                        Spacer()
                        Button(action: { self.selectedIndex = number }, label: {
                            if number == 2 { Image(systemName: icons[number])
                                    .font(
                                        .system(size: scs/25, weight: .regular, design: .default))
                                    .foregroundColor(
                                        Color(.systemBackground))
                                    .frame(width: scs/12, height: scs/12)
                                    .background(
                                        selectedIndex == number ? Color.accentColor : .gray)
                                    .cornerRadius(scs/10)
                            }
                            else {
                                VStack {
                                    Image(systemName: icons[number])
                                        .font(.system(size: number == 0 ? scs/25 : number == 1 ? scs/30 : scs/23, weight: .regular, design: .default))
                                    .frame(width: scs/25, height: scs/25)
                                    .foregroundColor(selectedIndex == number ? .accentColor : .gray)
                                    Text(names[number])
                                        .foregroundColor(selectedIndex == number ? .accentColor : .gray).font(.system(size: 10, weight: .bold, design: .default))
                                }
                            }
                        })
                        Spacer()
                    }
                }
                .padding(EdgeInsets(
                    top: scs < 800 ? 5 : 10,
                    leading: scs/100,
                    bottom: scs < 800 ? 30 : 30,
                    trailing: scs/100))
                
                .background(colorScheme == .dark ?
                            Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
            }
            .offset(x: 0, y: scs < 800 ? scs/2.2 : scs/2.33)
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
