//
//  MyAllRoutesFromNodeMultiType.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/29.
//

import Foundation

enum MyAllRoutesFromNodeMultiType: Decodable {
    case listItem([AllRoutesFromNodeInfo])
    case oneItem(AllRoutesFromNodeInfo)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let myValue = try? container.decode([AllRoutesFromNodeInfo].self) {
            self = .listItem(myValue)
            return
        }

        if let myValue = try? container.decode(AllRoutesFromNodeInfo.self) {
            self = .oneItem(myValue)
            return
        }

        throw DecodingError.typeMismatch(
            MyAllRoutesFromNodeMultiType.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }

    var listValue: [AllRoutesFromNodeInfo] {
        switch self {
        case .oneItem(let item):
            return [item]

        case .listItem(let items):
            return items
        }
    }
}
