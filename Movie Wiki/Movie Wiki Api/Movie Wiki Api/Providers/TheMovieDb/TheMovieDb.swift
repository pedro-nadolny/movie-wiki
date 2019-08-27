import Moya
import Movie_Wiki_Commons

public enum TheMovieDb {
    case getUpcomingMovies(page: Int)
    case getMovie(id: Int)
    case getPoster(file: String)
    case getBackdrop(file: String)
}

extension TheMovieDb: TargetType {    
    public var baseURL: URL {
        switch self {
        case .getPoster, .getBackdrop: return URL(string: "https://image.tmdb.org/t/p")!
        default: return URL(string: "https://api.themoviedb.org/3")!
        }
    }
    
    public var path: String {
        switch self {
        case .getUpcomingMovies: return "/movie/upcoming"
        case .getMovie(let id): return "/movie/\(id)"
        case .getPoster(let file): return "/w154/" + file
        case .getBackdrop(let file): return "/w780/" + file
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUpcomingMovies: return .get
        case .getMovie: return .get
        case .getPoster: return .get
        case .getBackdrop: return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getPoster, .getBackdrop:
            return .requestPlain
        
        default:
            return .requestParameters (
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json;charset=utf-8"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    fileprivate var parameters: [String: Any] {
        var parameters: [String: Any] = [
            "api_key": "1f54bd990f1cdfb230adb312546d765d",
            "language": "pt-BR",
            "region": "BR"
        ]
        
        switch self {
        case .getUpcomingMovies(let page):
            parameters["page"] = page
            
        default: break
        }
        
        return parameters
    }
    
    public var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        switch self {
        case .getMovie, .getUpcomingMovies:
            decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
        default: break
        }
        
        return decoder
    }
}
