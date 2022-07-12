//
//  FirstView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("이미 계정이 있다면")
                .foregroundColor(ColorManager.LightColor)
            Button(action: { LoginView() }) {
                Text("로그인")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(ColorManager.LightColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            Text("처음 설치하셨다면")
                .foregroundColor(.accentColor)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
            Button(action: { RegisterView() }) {
                Text("회원가입")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .padding(20)
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
