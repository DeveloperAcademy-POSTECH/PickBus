//
//  SearchNode.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/20.
//

import Foundation

struct SearchNode: Decodable {
    let response: SearchNodeResponse
}

struct SearchNodeResponse: Decodable {
    let header: SearchNodeResponseHeader
    let body: SearchNodeResponseBody
}

struct SearchNodeResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct SearchNodeResponseBody: Decodable {
    let items: SearchNodeResponseItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct SearchNodeResponseItem: Decodable {
    let item: MySearchNodeInfo

}

struct SearchNodeInfo: Decodable {
    /// WGS84 위도 좌표
    let gpslati: Double
    /// WGS84 경도 좌표
    let gpslong: Double
    /// 정류장 ID
    let nodeid: String
    /// 정류장 이름
    let nodenm: String
    /// 정류장 번호
    let nodeno: Int
}
