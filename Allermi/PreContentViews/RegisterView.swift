//
//  RegisterView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("세상 모든\n알레르기 환자를 위하여")
                .font(.system(size: 30, weight: .bold, design: .default))
            Text("알레르미는 식품 알레르기로부터\n안전한 세상을 만듭니다.")
                .font(.system(size: 20, weight: .medium, design: .default))
                .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                .foregroundColor(.gray)
            Spacer()
            NavigationLink(destination: IDView()) {
                Text("가입하기")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
    }
}

struct IDView: View {
    @FocusState private var isFocused: Bool
    @State var registerId: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임을 생성해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack {
                TextField("닉네임", text: $registerId)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused)
                Rectangle()
                    .fill(isFocused ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            HStack(spacing: 0) {
                Text("16자리 이하의 ")
                    .foregroundColor(registerId.count != 0 && registerId.count <= 16 ? .accentColor : Color(.systemGray3))
                Text("숫자나 문자")
                    .foregroundColor(registerId.count != 0 ? .accentColor : Color(.systemGray3))
            }
            Spacer()
            NavigationLink(destination: PWView()) {
                Text("다음")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(registerId.count == 0 || registerId.count > 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
    }
}

struct PWView: View {
    @FocusState private var isFocused: Bool
    @State var registerPw: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("비밀번호를 생성해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack {
                SecureField("비밀번호", text: $registerPw)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused)
                Rectangle()
                    .fill(isFocused ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            HStack(spacing: 0) {
                Text("8자리 이상의 ")
                    .foregroundColor(registerPw.count >= 8 ? .accentColor : Color(.systemGray3))
                Text("숫자")
                    .foregroundColor(!registerPw.isEmpty && !registerPw.filter("0123456789.".contains).isEmpty ? .accentColor : Color(.systemGray3))
                Text("와 ")
                    .foregroundColor(!registerPw.isEmpty && !registerPw.filter("0123456789.".contains).isEmpty && Int(registerPw) == nil ? .accentColor : Color(.systemGray3))
                Text("문자")
                    .foregroundColor(!registerPw.isEmpty && Int(registerPw) == nil ? .accentColor : Color(.systemGray3))
                Text(" 조합")
                    .foregroundColor(!registerPw.isEmpty && !registerPw.filter("0123456789.".contains).isEmpty && Int(registerPw) == nil ? .accentColor : Color(.systemGray3))
            }
            Spacer()
            NavigationLink(destination: AllergyView()) {
                Text("다음")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(registerPw.count < 8 || registerPw.filter("0123456789.".contains).isEmpty || Int(registerPw) != nil)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
    }
}

struct AllergyView: View {
    @FocusState private var isFocused: Bool
    @State var allergySearch: String = ""
    @State var allergyList = [Int]()
    var body: some View {
        VStack(alignment: .leading) {
            Text("알레르기를 선택해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack {
                TextField("검색", text: $allergySearch)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused)
                Rectangle()
                    .fill(isFocused ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            NavigationLink(destination: EndView()) {
                Text("다음")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(allergyList.isEmpty)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
    }
}

struct EndView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("회원가입 완료")
                .font(.system(size: 30, weight: .bold, design: .default))
            Text("환영합니다!\n시작하기 버튼을 눌러 시작하세요.")
                .font(.system(size: 20, weight: .medium, design: .default))
                .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                .foregroundColor(.gray)
            Spacer()
            NavigationLink(destination: ContentView()) {
                Text("시작하기")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .foregroundColor(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .padding(20)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        AllergyView()
    }
}
