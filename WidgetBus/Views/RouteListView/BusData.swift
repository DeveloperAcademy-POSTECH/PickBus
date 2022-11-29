//
//  RouteListData.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/13.
//

import Foundation

// Dummy-data

// 정류장
struct Nodee {
    var cityCode: String
    var nodeId: String
    var nodeNm: String
}

// 로트
struct Route {
    var routeNo: Int
    var routeArr: Int?
    var routeNaextArr: Int?
    var routearrprevstationcnt: Int?
}
