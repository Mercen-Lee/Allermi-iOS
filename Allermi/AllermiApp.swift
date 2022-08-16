//
//  AllermiApp.swift
//  Allermi
//
//  Created by Mercen on 2022/07/11.
//

import SwiftUI

public let allergyLists = ["난류": ["달걀", "계란", "메추리알"],
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

public let allergyKeyLists = ["난류", "육류", "닭고기", "생선류", "갑각류", "연체동물류", "유류", "견과류", "대두", "꽃가루-식품", "토마토", "밀", "메밀", "아황산류"]
public let api = "http://43.200.182.132"

@main
struct AllermiApp: App {
    public let token = UserDefaults.standard.string(forKey: "token")
    var body: some Scene {
        WindowGroup {
            if token != nil {
                ContentView()
            } else { FirstView() }
        }
    }
}
