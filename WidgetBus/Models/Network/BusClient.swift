//
//  BusClient.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import Foundation

class BusClient {

    static var apiKey: String {

        guard let url = Bundle.main.url(forResource: "Service Key", withExtension: "plist") else {
            return ""
        }
        guard let dictionary = NSDictionary(contentsOf: url) else {
            return ""
        }

        return dictionary["BusStop"] as? String ?? ""
    }

    enum Endpoints {
        static let base = "http://apis.data.go.kr"
        static let apiKeyParam = "?serviceKey=\(BusClient.apiKey)"

        case getArriveList(city: String, busStopId: String)
        case getCityCodeList
        case getNodesList(city: String, routeId: String, pageNumber: String = "1")
        case searchNode(city: String, nodeName: String?, nodeNumber: String?)
        case getRouteInformation(city: String, routeId: String)
        case getBusLocationsOnRoute(city: String, routeId: String)
        case getSpecificArrive(city: String, routeId: String, nodeId: String)

        var stringValue: String {
            switch self {
            case .getArriveList(let city, let busStopId):
                return Endpoints.base +
                "/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList" +
                Endpoints.apiKeyParam +
                "&_type=json&cityCode=\(city)&nodeId=\(busStopId)&numOfRows=99"

            case .getCityCodeList:
                return Endpoints.base +
                "/1613000/BusSttnInfoInqireService/getCtyCodeList" +
                Endpoints.apiKeyParam + "&_type=json"

            case .getNodesList(let city, let routeId, let pageNumber):
                return Endpoints.base +
                "/1613000/BusRouteInfoInqireService/getRouteAcctoThrghSttnList" +
                Endpoints.apiKeyParam +
                "&_type=json&cityCode=\(city)&routeId=\(routeId)&numOfRows=99"
                +
                "&pageNo=\(pageNumber)"

            case .searchNode(let city, let nodeName, let nodeNumber):
                var url = ""

                var isNodeName = false
                var isNodeNumber = false
                nodeName == nil ? (isNodeName = false) : (isNodeName = true)
                nodeNumber == nil ? (isNodeNumber = false) : (isNodeNumber = true)

                if isNodeName {
                    let escapedNodeNm =
                    nodeName!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    url = Endpoints.base +
                    "/1613000/BusSttnInfoInqireService/getSttnNoList" +
                    Endpoints.apiKeyParam +
                    "&_type=json&cityCode=\(city)&nodeNm=\(escapedNodeNm ?? "")" +
                    "&numOfRows=99"
                } else if isNodeNumber {
                    url = Endpoints.base +
                    "/1613000/BusSttnInfoInqireService/getSttnNoList" +
                    Endpoints.apiKeyParam +
                    "&_type=json&cityCode=\(city)&nodeNo=\(nodeNumber!)" +
                    "&numOfRows=99"
                } else {
                    return url
                }
                return url

            case .getRouteInformation(let city, let routeId):
                return Endpoints.base +
                "/1613000/BusRouteInfoInqireService/getRouteInfoIem" +
                Endpoints.apiKeyParam +
                "&_type=json&cityCode=\(city)&routeId=\(routeId)"

            case .getBusLocationsOnRoute(let city, let routeId):
                return Endpoints.base +
                "/1613000/BusLcInfoInqireService/getRouteAcctoBusLcList" +
                Endpoints.apiKeyParam +
                "&_type=json&cityCode=\(city)&routeId=\(routeId)&numOfRows=99"

            case .getSpecificArrive(let city, let routeId, let nodeId):
                return Endpoints.base +
                "/1613000/ArvlInfoInqireService/getSttnAcctoSpcifyRouteBusArvlPrearngeInfoList" +
                Endpoints.apiKeyParam +
                "&_type=json&cityCode=\(city)&nodeId=\(nodeId)&routeId=\(routeId)&numOfRows=99"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func taskForGETRequest<ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()

        return task
    }

    class func taskForGetRequestWithCityCode<ResponseType: Decodable>(
        url: URL,
        cityCode: Int,
        responseType: ResponseType.Type,
        completion: @escaping (Int?, ResponseType?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {

                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(cityCode, responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
            }
        }
        task.resume()

        return task
    }

    class func searchNodeList(
        city: String = "25",
        nodeName: String? = "전통시장",
        nodeNumber: String? = "44810",
        completion: @escaping (Int?, [SearchNodeInfo], Error?) -> Void
    ) -> URLSessionDataTask {
        let myTask = taskForGetRequestWithCityCode(
            url: Endpoints.searchNode(
                city: city,
                nodeName: nodeName,
                nodeNumber: nodeNumber).url,
            cityCode: Int(city) ?? 0,
            responseType: SearchNode.self) { city, response, error in
                if let response = response {
                    completion(city, response.response.body.items.item.listValue, nil)
                } else {
                    completion(nil, [], error)
                }
            }

        return myTask
    }

    class func getArriveList(
        city: String = "25",
        nodeId: String = "DJB8001793",
        completion: @escaping ([ArriveInfoResponseArriveInfo], Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getArriveList(city: "25", busStopId: "DJB8001793").url,
                responseType: ArriveInfoFromBusStop.self) { response, error in
                    if let response = response {
                        completion(response.response.body.items.item, nil)
                    } else {
                        completion([], error)
                    }
                }
        }

    class func getNodesListBody(
        city: String = "25",
        routeId: String = "DJB30300004",
        completion: @escaping (RouteNodesResponseBody?, Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getNodesList(city: city, routeId: routeId).url,
                responseType: RouteNodes.self) { response, error in
                    if let response = response {
                        completion(response.response.body, nil)
                    } else {
                        completion(nil, error)
                    }
                }
        }

    class func getNodeList (
        city: String = "25",
        routeId: String = "DJB30300004",
        pageNo: String = "1",
        completion: @escaping ([RouteNodesInfo], Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getNodesList(city: city, routeId: routeId, pageNumber: pageNo).url,
                responseType: RouteNodes.self) { response, error in
                    if let response = response {
                        completion(response.response.body.items.item, nil)
                    } else {
                        completion([], error)
                    }
                }
        }

    class func getCityCodeList (
        completion: @escaping ([CityCodeInfo], Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getCityCodeList.url,
                responseType: CityCode.self) { response, error in
                    if let response = response {
                        completion(response.response.body.items.item, nil)
                    } else {
                        completion([], error)
                    }
                }
        }
    class func getRouteInformation (
        city: String = "25",
        routeId: String = "DJB30300004",
        completion: @escaping (RouteInformationInfo?, Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getRouteInformation(city: city, routeId: routeId).url,
                responseType: RouteInformation.self, completion: { response, error in
                    if let response = response {
                        completion(response.response.body.items.item, nil)
                    } else {
                        completion(nil, error)
                    }
                })
        }

    class func getLocationsOnRoute(
        city: String = "25",
        routeId: String = "DJB30300004",
        completion: @escaping ([BusLocationsInfo], Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getBusLocationsOnRoute(city: city, routeId: routeId).url,
                responseType: BusLocationsOnRoute.self, completion: { response, error in
                    if let response = response {
                        completion(response.response.body.items.item, nil)
                    } else {
                        completion([], error)
                    }
                })
        }

    class func getSpecificArrive(
        city: String = "25",
        routeId: String = "DJB30300004",
        nodeId: String = "DJB8001793",
        completion: @escaping (SpecificArriveInfo?, Error?) -> Void) {
            _ = taskForGETRequest(
                url: Endpoints.getSpecificArrive(
                    city: city, routeId: routeId, nodeId: nodeId).url, responseType: SpecificArrive.self,
                completion: { response, error in
                    if let response = response {
                        completion(response.response.body.items.item, nil)
                    } else {
                        completion(nil, error)
                    }
                })
        }

}
