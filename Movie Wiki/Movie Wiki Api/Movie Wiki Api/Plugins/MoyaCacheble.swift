import Foundation
import Moya

protocol MoyaCacheable {
    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}

final class MoyaCacheablePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let moyaCachableProtocol = target as? MoyaCacheable else {
            return request
        }
        
        var cachableRequest = request
        cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
        return cachableRequest
    }
}
