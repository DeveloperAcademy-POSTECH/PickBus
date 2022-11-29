//
//  ArriveInfoMultiTypes.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/26.
//

import Foundation

enum ArriveInfoMultiTypes: Decodable {
case listItem([ArriveInfoResponseArriveInfo])
case oneItem(ArriveInfoResponseArriveInfo)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let myValue = try? container.decode([ArriveInfoResponseArriveInfo].self) {
            self = .listItem(myValue)
            return
        }

        if let myValue = try? container.decode(ArriveInfoResponseArriveInfo.self) {
            self = .oneItem(myValue)
            return
        }

        throw DecodingError.typeMismatch(
            MySearchNodeInfo.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Mismatched type"))

    }

    var listValue: [ArriveInfoResponseArriveInfo] {
        switch self {
        case .oneItem(let item):
            return [item]

        case .listItem(let items):
            return items
        }
    }
}
