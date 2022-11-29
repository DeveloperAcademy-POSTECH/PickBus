//
//  AllRoutesFromNode.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/29.
//

import Foundation

struct AllRoutesFromNode: Decodable {
    let response: AllRoutesFromNodeResponseAPI
}

struct AllRoutesFromNodeResponseAPI: Decodable {
    let header: AllRoutesFromNodeResponseHeader
    let body: AllRoutesFromNodeResponseBody
}

struct AllRoutesFromNodeResponseHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct AllRoutesFromNodeResponseBody: Decodable {
    let items: AllRoutesFromNodeItem
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct AllRoutesFromNodeItem: Decodable {
    let item: MyAllRoutesFromNodeMultiType
}

struct AllRoutesFromNodeInfo: Decodable {
    let endnodenm: String
    let routeid: String
    let routeno: StringMultiType
    let routetp: String
    let startnodenm: String
}
