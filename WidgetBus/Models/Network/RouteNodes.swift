//
//  RouteBusStops.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/15.
//

import Foundation

struct RouteNodes: Decodable {
    let response: RouteNodesResponseAPI
}

struct RouteNodesResponseAPI: Decodable {
    let header: RouteNodesResponseHeader
    let body: RouteNodesResponseBody
}

struct RouteNodesResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct RouteNodesResponseBody: Decodable {
    let items: RouteNodesResponseItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct RouteNodesResponseItem: Decodable {
    let item: [RouteNodesInfo]
}

struct RouteNodesInfo: Decodable {
    /// WGS84 위도 좌표
    let gpslati: Double
    /// WGS84 경도 좌표
    let gpslong: Double
    /// 정류소 ID
    let nodeid: String
    /// 정류소 명
    let nodenm: String
    /// 정류소 번호
    let nodeno: Int
    /// 정류소 순번
    let nodeord: Int
    /// 노선 ID
    let routeid: String
    /// 상하행 구분 코드
    let updowncd: Int
}
