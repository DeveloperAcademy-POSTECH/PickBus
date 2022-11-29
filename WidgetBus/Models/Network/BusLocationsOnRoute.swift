//
//  BusLocationsOnRoute.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/17.
//

import Foundation

struct BusLocationsOnRoute: Decodable {
    let response: BusLocationsResponse
}

struct BusLocationsResponse: Decodable {
    let header: BusLocationsResponseHeader
    let body: BusLocationsResponseBody
}

struct BusLocationsResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct BusLocationsResponseBody: Decodable {
    let items: BusLocationsResponseItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct BusLocationsResponseItems: Decodable {
    let item: [BusLocationsInfo]
}

struct BusLocationsInfo: Decodable {
    /// WGS84 위도 좌표
    let gpslati: Double
    /// WGS84 경도 좌표
    let gpslong: Double
    /// 정류장 ID
    let nodeid: String
    /// 정류장 이름
    let nodenm: String
    /// 정류장 순서
    let nodeord: Int
    /// 노선 번호
    let routenm: Int
    /// 노선 유형(간선 버스 등)
    let routetp: String
    /// 차량 번호(대전99가9999 등)
    let vehicleno: String
}
