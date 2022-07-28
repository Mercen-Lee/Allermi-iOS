//
//  LoginView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}

struct LoginView: View {
    @FocusState private var isFocused1: Bool
    @FocusState private var isFocused2: Bool
    @State var loginId: String = ""
    @State var loginPw: String = ""
    @State var invalidId = 0
    @State var invalidPw = 0
    @State var emptyId = false
    @State var emptyPw = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("알레르미 로그인")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack {
                TextField("닉네임", text: $loginId)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused1)
                Rectangle()
                    .fill(isFocused1 ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            .modifier(ShakeEffect(animatableData: CGFloat(invalidId)))
            Text("없는 닉네임입니다")
                .foregroundColor(.accentColor)
                .isHidden(!emptyId || loginId.count != 0)
            VStack {
                SecureField("비밀번호", text: $loginPw)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused2)
                Rectangle()
                    .fill(isFocused2 ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .modifier(ShakeEffect(animatableData: CGFloat(invalidPw)))
            Text("비밀번호가 틀렸습니다")
                .foregroundColor(.accentColor)
                .isHidden(!emptyPw || loginPw.count != 0)
            Spacer()
            Button(action: { withAnimation(.default) {
                if(loginId.count == 0) {
                    emptyId = true
                    self.invalidId += 1
                }
                if(loginPw.count == 0) {
                    emptyPw = true
                    self.invalidPw += 1
                }
            }}) {
                Text("로그인")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(loginId.isEmpty || loginPw.isEmpty)
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
