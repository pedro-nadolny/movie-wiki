import Foundation
import Moya
import Movie_Wiki_Api

class MovieDetailsViewModel {
    let provider: MoyaProvider<TheMovieDb>
    
    init(provider: MoyaProvider<TheMovieDb>) {
        self.provider = provider
    }
}
