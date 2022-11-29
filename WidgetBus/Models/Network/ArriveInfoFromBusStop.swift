//
//  ArriveInfoFromBusStop.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import Foundation

struct ArriveInfoFromBusStop: Decodable {
    let response: ArriveInfoResponseAPI
}

struct ArriveInfoResponseAPI: Decodable {
    let header: ArriveInfoResponseHeader
    let body: ArriveInfoResponseBody
}

struct ArriveInfoResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct ArriveInfoResponseBody: Decodable {
    let items: ArriveInfoResponseArriveItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct ArriveInfoResponseArriveItem: Decodable {
    let item: ArriveInfoMultiTypes
}

struct ArriveInfoResponseArriveInfo: Decodable {
    /// 도착예정버스 남은 정류장 수
    let arrprevstationcnt: Int
    /// 도착예정버스 도착예정 시간[초]
    let arrtime: Int
    /// 정류소 ID
    let nodeid: String
    /// 정류소 명
    let nodenm: String
    /// 노선 ID
    let routeid: String
    /// 노선 번호
    let routeno: StringMultiType
    /// 노선 유형(마을 버스 등)
    let routetp: String
    /// 도착예정버스 차량유형(저상 버스 등)
    let vehicletp: String
}
