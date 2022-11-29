//
//  RouteListData.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/13.
//

import Foundation

// Dummy-data
struct BusData {

    struct BusStop {
        var name: String
        var routes: [Route]

    }
    struct Route {
        var busNumber: String
        var busRemainingTime: String
        var nextBusRemainingTimeLabel: String
    }
}

extension BusData {
    static let busStops: [BusStop] = [
        BusStop(name: "포스텍", routes: [
            Route(busNumber: "207", busRemainingTime: "9분", nextBusRemainingTimeLabel: "21분"),
            Route(busNumber: "210", busRemainingTime: "전전", nextBusRemainingTimeLabel: "5분"),
            Route(busNumber: "70", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "9분"),
            Route(busNumber: "102", busRemainingTime: "7분", nextBusRemainingTimeLabel: "27분"),
            Route(busNumber: "105", busRemainingTime: "전", nextBusRemainingTimeLabel: "8분")
        ]),
        BusStop(name: "신분당선강남역", routes: [
            Route(busNumber: "5007", busRemainingTime: "전전", nextBusRemainingTimeLabel: "6분"),
            Route(busNumber: "5003", busRemainingTime: "곧도착", nextBusRemainingTimeLabel: "7분"),
            Route(busNumber: "5006", busRemainingTime: "3분", nextBusRemainingTimeLabel: "9분"),
            Route(busNumber: "5107", busRemainingTime: "16분", nextBusRemainingTimeLabel: "20분")
        ]),
        BusStop(name: "잔다리마을이영미술관", routes: [
            Route(busNumber: "55", busRemainingTime: "7분", nextBusRemainingTimeLabel: "22분"),
            Route(busNumber: "28-2", busRemainingTime: "5분", nextBusRemainingTimeLabel: "17분"),
            Route(busNumber: "10-5", busRemainingTime: "4분", nextBusRemainingTimeLabel: "9분")
        ]),
        BusStop(name: "효자시장", routes: [
            Route(busNumber: "210", busRemainingTime: "9분", nextBusRemainingTimeLabel: "13분"),
            Route(busNumber: "207", busRemainingTime: "전전", nextBusRemainingTimeLabel: "13분"),
            Route(busNumber: "210", busRemainingTime: "5분", nextBusRemainingTimeLabel: "13분")
        ])
    ]
}
