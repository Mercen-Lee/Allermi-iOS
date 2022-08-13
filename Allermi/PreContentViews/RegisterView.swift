//
//  RegisterView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/12.
//

import SwiftUI
import Alamofire
import CryptoKit

public struct MultilineHStack: View {
    struct SizePreferenceKey: PreferenceKey {
        typealias Value = [CGSize]
        static var defaultValue: Value = []
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.append(contentsOf: nextValue())
        }
    }

    private let items: [AnyView]
    @State private var sizes: [CGSize] = []

    public init<Data: RandomAccessCollection,  Content: View>(_ data: Data, @ViewBuilder content: (Data.Element) -> Content) {
          self.items = data.map { AnyView(content($0)) }
    }

    public var body: some View {
        GeometryReader {geometry in
            ZStack(alignment: .topLeading) {
                ForEach(0..<self.items.count, id: \.self) { index in
                    self.items[index].background(self.backgroundView()).offset(self.getOffset(at: index, geometry: geometry))
                }
            }
        }.onPreferenceChange(SizePreferenceKey.self) {
                self.sizes = $0
        }
    }

    private func getOffset(at index: Int, geometry: GeometryProxy) -> CGSize {
        guard index < sizes.endIndex else {return .zero}
        let frame = sizes[index]
        var (x,y,maxHeight) = sizes[..<index].reduce((CGFloat.zero,CGFloat.zero,CGFloat.zero)) {
            var (x,y,maxHeight) = $0
            x += $1.width
            if x > geometry.size.width {
                x = $1.width
                y += maxHeight
                maxHeight = 0
            }
            maxHeight = max(maxHeight, $1.height)
            return (x,y,maxHeight)
        }
        if x + frame.width > geometry.size.width {
            x = 0
            y += maxHeight
        }
        return .init(width: x, height: y)
    }

    private func backgroundView() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: SizePreferenceKey.self,
                    value: [geometry.frame(in: CoordinateSpace.global).size]
                )
        }
    }
}


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
                AF.request("\(api)/user/\(registerId)/check", method: .get, encoding: URLEncoding.default)
                    .responseData { response in
                        print(String(decoding: response.data!, as: UTF8.self))
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
            NavigationLink(destination: PWView(), isActive: $nextView) { EmptyView() }
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
            NavigationLink(destination: AllergyView()) {
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
    @State var allergySearch: String = ""
    @State var allergyList = [Int]()
    @State var allergyLists = ["난류": ["달걀", "계란", "메추리알"],
                               "육류": ["소고기", "쇠고기", "돼지고기"],
                               "닭고기": [],
                               "생선류": ["고등어", "연어", "전어", "멸치", "명태", "참치", "삼치", "꽁치", "생선"],
                               "갑각류": ["새우", "게", "가재"],
                               "연체동물류": ["오징어", "조개", "가리비", "홍합", "굴"],
                               "유류": ["우유", "양유"],
                               "견과류": ["땅콩", "호두", "잣", "마카다미아", "헤이즐넛", "캐슈넛", "아몬드", "피스타치오"],
                               "대두": ["콩"],
                               "꽃가루-식품": ["복숭아", "사과", "자두", "키위"],
                               "토마토": [],
                               "밀": [],
                               "메밀": [],
                               "아황산류": []]
    @State var selectedAllergy = [String]()
    @State var viewLists = [String]()
    func chooseString(arg: String) {
        for i in Array(allergyLists.keys) {
            if(allergyLists[i]!.contains(arg) || i == arg) {
                
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("알레르기를 선택해주세요.")
                .font(.system(size: 30, weight: .bold, design: .default))
            VStack(alignment: .leading) {
                MultilineHStack(viewLists) { idx in
                    Button(action: {
                        if selectedAllergy.contains(idx) {
                            selectedAllergy = selectedAllergy.filter(){$0 != idx}
                        } else {
                            selectedAllergy.append(idx)
                        }
                    }) {
                        Text(idx)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .foregroundColor(selectedAllergy.contains(idx) ? .accentColor : Color(.systemGray3))
                            .frame(height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selectedAllergy.contains(idx) ? .accentColor : Color(.systemGray3), lineWidth: 1)
                            )
                    }
                    .padding(5)
                }
            }
            .padding(.top, 10)
            Spacer()
            NavigationLink(destination: EndView()) {
                allermiButton(buttonTitle: "다음", buttonColor: Color.accentColor)
            }
            .disabled(allergyList.isEmpty)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .padding(20)
        .onAppear {
            for i in Array(allergyLists.keys) {
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
        AllergyView()
    }
}
