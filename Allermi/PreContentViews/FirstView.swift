//
//  FirstView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct allermiButton: View {
    let buttonTitle: String
    let buttonColor: Color
    var body: some View {
        Text(buttonTitle)
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(buttonColor)
            .foregroundColor(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct FirstView: View {
    @State var devMenu = false
    @State var showVersion = false
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270)
                    .onLongPressGesture(minimumDuration: 0.5) {
                        devMenu.toggle()
                    }
                Spacer()
                Text("이미 계정이 있다면")
                    .foregroundColor(Color("LightColor"))
                NavigationLink(destination: LoginView()) {
                    allermiButton(buttonTitle: "로그인", buttonColor: Color("LightColor"))
                }
                Text("처음 설치하셨다면")
                    .foregroundColor(.accentColor)
                    .padding(.top, 10)
                NavigationLink(destination: RegisterView()) {
                    allermiButton(buttonTitle: "회원가입", buttonColor: Color.accentColor)
                }
                VStack {
                    Text("DEVELOPER MENU")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    NavigationLink(destination: ContentView()) {
                        allermiButton(buttonTitle: "SEARCH SHORTCUT", buttonColor: Color.gray)
                    }
                    Button(action: { showVersion = true }) {
                        allermiButton(buttonTitle: "INFORMATION", buttonColor: Color.gray)
                    }
                    .alert("Allermi Developer Beta v0.2", isPresented: $showVersion) {
                        Button("OK", role: .cancel) { showVersion = false }
                    }
                }
                .isHidden(!devMenu, remove: true)
            }
            .padding(20)
            .navigationBarTitle("")
        }
        .navigationBarHidden(true)
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
