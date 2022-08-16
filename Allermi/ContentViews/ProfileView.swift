//
//  ProfileView.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI
import Alamofire
import WrappingHStack

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var userId = ""
    @Binding var logout: Bool
    @State var selectedAllergy = [String]()
    @State var relatedAllergy = [String]()
    @State var viewLists = [String]()
    func loadMyInfo() {
        AF.request("\(api)/sign", method: .get, encoding: URLEncoding.default, headers: ["ACCESS_TOKEN": UserDefaults.standard.string(forKey: "token")!, "Content-Type": "application/json"])
            .responseData { response in
                print(String(decoding: response.data!, as: UTF8.self))
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(UserInfo.self, from: value) else { return }
                self.selectedAllergy = result.allergy
                for idx in result.allergy {
                    self.relatedAllergy += chooseString(idx)
                }
                self.userId = result.userid
        }
    }
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
    let decoder: JSONDecoder = JSONDecoder()
    var body: some View {
        NavigationView {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("알레르미 회원")
                            .font(.caption)
                        Text(userId)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
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
                .padding(20)
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
                Button(action: { }) {
                    HStack {
                        Text("비밀번호 변경")
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 10)
                
                Button(action: {
                    UserDefaults.standard.removeObject(forKey: "token")
                    logout.toggle()
                }) {
                    HStack {
                        Text("로그아웃")
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 10)
                
                Button(action: { }) {
                    HStack {
                        Text("회원탈퇴")
                            .padding(.leading, 20)
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color("GrayColor").opacity(colorScheme == .dark ? 0.7 : 0.9))
                }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 100)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("프로필")
            
            
        }.onAppear {
            for i in allergyKeyLists {
                viewLists.append(i)
                viewLists += allergyLists[i]!
            }
            loadMyInfo()
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
