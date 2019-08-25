import Foundation

public struct MovieDetails: Decodable {
    public let id: Int
    public let backdropPath: String?
    public let title: String
    public let voteAverage: Double
    public let runtime: Int
    public let releaseDate: Date
    public let budget: Int
    public let overview: String
    public let revenue: Int
    public let genres: [Genres]
    
    public struct Genres: Decodable {
        public let id: Int
        public let name: String
    }
}
