//
//  FirstView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct FirstView: View {
    @State var devMenu = false
    @State var showVer = false
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 45, trailing: 40))
                    .onLongPressGesture(minimumDuration: 0.5) {
                        devMenu.toggle()
                    }
                Spacer()
                Text("이미 계정이 있다면")
                    .foregroundColor(ColorManager.LightColor)
                NavigationLink(destination: LoginView()) {
                    Text("로그인")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(ColorManager.LightColor)
                        .foregroundColor(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                Text("처음 설치하셨다면")
                    .foregroundColor(.accentColor)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                NavigationLink(destination: RegisterView()) {
                    Text("회원가입")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.accentColor)
                        .foregroundColor(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                VStack {
                    Text("DEVELOPER MENU")
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    NavigationLink(destination: ContentView()) {
                        Text("SEARCH SHORTCUT")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray)
                            .foregroundColor(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    NavigationLink(destination: DEVELOPERS()) {
                        Text("DEVELOPERS")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray)
                            .foregroundColor(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    Button(action: { showVer = true }) {
                        Text("INFORMATION")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray)
                            .foregroundColor(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .alert("Allermi Developer Beta v0.1", isPresented: $showVer) {
                        Button("OK", role: .cancel) { showVer = false }
                    }
                }
                .isHidden(!devMenu, remove: true)
            }
            .padding(20)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
