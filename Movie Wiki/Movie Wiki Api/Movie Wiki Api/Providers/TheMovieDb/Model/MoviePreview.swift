import Foundation

public struct MoviePreview: Decodable {
    public let id: Int
    public let title: String
    public let voteAverage: Double
    public let releaseDate: Date
    public let posterPath: String?
    
    // MARK: - Page
    public struct Page: Decodable {
        public let page: Int
        public let totalPages: Int
        public let moviePreviews: [MoviePreview]
        
        private enum Keys: String, CodingKey {
            case page
            case totalPages
            case moviePreviews = "results"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            page = try container.decode(Int.self, forKey: .page)
            totalPages = try container.decode(Int.self, forKey: .totalPages)
            moviePreviews = try container.decode([MoviePreview].self, forKey: .moviePreviews)
        }
    }
}
