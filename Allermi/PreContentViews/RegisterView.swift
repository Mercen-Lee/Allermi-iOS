//
//  RegisterView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import AVKit
import WrappingHStack

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
    @State private var nextView = false
    @State var audioPlayer: AVAudioPlayer!
    @State var duplicateIDwarning = false
    @State var duplicateID = 0
    @State var registerId: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("아이디를 생성해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack(alignment: .leading) {
                TextField("아이디", text: $registerId)
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .focused($isFocused)
                Rectangle()
                    .fill(isFocused ? .accentColor : Color(.systemGray3))
                    .frame(height: 1.3)
                HStack(spacing: 0) {
                    Text("16자리 이하의 ")
                        .foregroundColor(registerId.count != 0 && registerId.count <= 16 ? .accentColor : Color(.systemGray3))
                    Text("숫자나 문자")
                        .foregroundColor(registerId.count != 0 ? .accentColor : Color(.systemGray3))
                }
                .isHidden(duplicateID != 0 && duplicateIDwarning, remove: true)
                Text("이미 존재하는 닉네임입니다")
                    .isHidden(duplicateID == 0 || !duplicateIDwarning, remove: true)
                    .foregroundColor(.accentColor)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
            .modifier(ShakeEffect(animatableData: CGFloat(duplicateID)))
            Spacer()
            Button(action: {
                if registerId.uppercased() == "ZELDA" || registerId.uppercased() == "LINK" {
                    let sound = Bundle.main.path(forResource: "Secret", ofType: "mp3")
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    self.audioPlayer.play()
                }
                AF.request("\(api)/user/\(registerId)", method: .get, encoding: URLEncoding.default)
                    .responseData { response in
                    if String(data: response.data!, encoding: .utf8)! == "true" {
                        withAnimation(.default) {
                            self.duplicateIDwarning = true
                            self.duplicateID += 1
                        }
                    }
                    else { nextView.toggle() }
                }
            }) {
                allermiButton(buttonTitle: "다음", buttonColor: Color.accentColor)
            }
            .disabled(registerId.count == 0 || registerId.count > 16)
            NavigationLink(destination: PWView(registerId: registerId), isActive: $nextView) { EmptyView() }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
    }
}

struct PWView: View {
    @FocusState private var isFocused: Bool
    @State var registerId: String
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
            .padding(.top, 25)
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
            NavigationLink(destination: AllergyView(registerId: registerId, registerPw: registerPw)) {
                allermiButton(buttonTitle: "다음", buttonColor: Color.accentColor)
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
    @State var completeRegister = false
    @State var registerId: String
    @State var registerPw: String
    @State var selectedAllergy = [String]()
    @State var relatedAllergy = [String]()
    @State var viewLists = [String]()
    func chooseString(_ arg: String) -> [String] {
        var result = [String]()
        for i in Array(allergyLists.keys) {
            if(allergyLists[i]!.contains(arg) || i == arg) {
                result = allergyLists[i]!
                result.append(i)
            }
        }
        return result.filter(){$0 != arg}
    }
    func chooseMajor(_ arg: String) -> String {
        var result = String()
        for i in Array(allergyLists.keys) {
            if(allergyLists[i]!.contains(arg) || i == arg) {
                result = i
            }
        }
        return result
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("알레르기를 선택해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            ScrollView {
                VStack(alignment: .leading) {
                    WrappingHStack(viewLists) { idx in
                        Button(action: {
                            if selectedAllergy.contains(chooseMajor(idx)) {
                                selectedAllergy = selectedAllergy.filter(){$0 != chooseMajor(idx)}
                                for i in chooseString(chooseMajor(idx)) {
                                    relatedAllergy = relatedAllergy.filter(){$0 != i}
                                }
                            } else {
                                selectedAllergy.append(chooseMajor(idx))
                                relatedAllergy += chooseString(chooseMajor(idx))
                            }
                        }) {
                            Text(idx)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .foregroundColor(selectedAllergy.contains(idx) ? .accentColor : relatedAllergy.contains(idx) ? Color("LightColor") : Color(.systemGray3))
                                .frame(height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedAllergy.contains(idx) ? .accentColor : relatedAllergy.contains(idx) ? Color("LightColor") : Color(.systemGray3), lineWidth: 1)
                                )
                        }
                        .padding([.leading, .trailing], 1.5)
                        .padding([.top, .bottom], 5)
                    }
                }
            }
            .padding(.top, 10)
            Spacer()
            Button(action: {
                AF.request("\(api)/sign/register", method: .post, parameters: ["userid": registerId, "password": registerPw, "allergy": selectedAllergy], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
                        .responseData { response in
                        if (response.response?.statusCode)! == 200 || (response.response?.statusCode)! == 201 {
                            AF.request("\(api)/sign/login", method: .post, parameters: ["userid": registerId, "password": registerPw], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
                                    .responseData { response in
                                    if (response.response?.statusCode)! == 200 || (response.response?.statusCode)! == 201 {
                                        UserDefaults.standard.set(JSON(response.data!)["data"]["token"].string, forKey: "token")
                                        completeRegister.toggle()
                                    } else {
                                        //예외 처리
                                    }
                                }
                        } else {
                            //예외 처리
                        }
                    }
            }) {
                allermiButton(buttonTitle: "다음", buttonColor: Color.accentColor)
            }
            .disabled(selectedAllergy.isEmpty)
            NavigationLink(destination: EndView(), isActive: $completeRegister) { EmptyView() }
        }
        .navigationBarItems(trailing: Button(action: {
            
        }) {
            Image(systemName: "info.circle")
                .foregroundColor(.accentColor)
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
        .onAppear {
            for i in allergyKeyLists {
                viewLists.append(i)
                viewLists += allergyLists[i]!
            }
        }
    }
}

struct EndView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("회원가입 완료")
                .font(.system(size: 30, weight: .bold, design: .default))
            Text("환영합니다!\n시작하기 버튼을 눌러 시작하세요.")
                .font(.system(size: 20, weight: .medium, design: .default))
                .padding(.top, 1)
                .foregroundColor(.gray)
            Spacer()
            NavigationLink(destination: ContentView()) {
                allermiButton(buttonTitle: "시작하기", buttonColor: Color.accentColor)
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
        EndView()
    }
}
