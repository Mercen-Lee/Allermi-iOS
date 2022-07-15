//
//  LoginView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct LoginView: View {
    @FocusState private var isFocused1: Bool
    @FocusState private var isFocused2: Bool
    @State private var NextView = false
    @State var loginId: String = ""
    @State var loginPw: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("알레르미 로그인")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack {
                TextField("아이디", text: $loginId)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused1)
                Rectangle()
                    .fill(isFocused1 ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            VStack {
                SecureField("비밀번호", text: $loginPw)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused2)
                Rectangle()
                    .fill(isFocused2 ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            Button(action: { NextView = true }) {
                Text("로그인")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
