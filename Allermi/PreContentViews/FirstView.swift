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
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 45, trailing: 40))
            Spacer()
            Text("이미 계정이 있다면")
                .foregroundColor(ColorManager.LightColor)
            Button(action: { LoginView() }) {
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
            Button(action: { RegisterView() }) {
                Text("회원가입")
                    .font(.system(size: 20, weight: .bold, design: .default))
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
