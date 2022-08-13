//
//  LoginView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI
import Alamofire
import SwiftyJSON

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
    @State var invalid = 0
    @State var success = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("알레르미 로그인")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack(alignment: .leading) {
                TextField("아이디", text: $loginId)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused1)
                    .padding(.top, 25)
                Rectangle()
                    .fill(isFocused1 ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
                SecureField("비밀번호", text: $loginPw)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused2)
                    .padding(.top, 25)
                Rectangle()
                    .fill(isFocused2 ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
                Text("아이디 또는 비밀번호가 틀렸습니다")
                    .foregroundColor(.accentColor)
                    .isHidden(invalid == 0)
            }
            .modifier(ShakeEffect(animatableData: CGFloat(invalid)))
            Spacer()
            NavigationLink(destination: ContentView(), isActive: $success) { EmptyView() }
            Button(action: {
                AF.request("\(api)/sign/login", method: .post, parameters: ["userid": loginId, "password": loginPw], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
                        .responseData { response in
                        if (response.response?.statusCode)! == 200 || (response.response?.statusCode)! == 201 {
                            UserDefaults.standard.set(JSON(response.data!)["data"]["token"].string, forKey: "token")
                            success.toggle()
                        } else {
                            withAnimation(.default) {
                            self.invalid += 1
                            }
                        }
                    }
            }) {
                allermiButton(buttonTitle: "로그인", buttonColor: Color.accentColor)
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
