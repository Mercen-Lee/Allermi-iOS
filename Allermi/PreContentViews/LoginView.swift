//
//  LoginView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct LoginView: View {
    @FocusState private var isFocused: Bool
    @State private var NextView = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("아이디를 입력해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack {
                TextField("아이디", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused)
                Rectangle()
                    .fill(isFocused ? .accentColor : Color(.tertiarySystemFill))
                    .frame(height: 1.6)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            Button(action: { NextView = true }) {
                Text("다음")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }.sheet(isPresented: $NextView) {
                IDView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(20)
    }
}

struct IDView: View {
    var body: some View {
        Text("")
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
