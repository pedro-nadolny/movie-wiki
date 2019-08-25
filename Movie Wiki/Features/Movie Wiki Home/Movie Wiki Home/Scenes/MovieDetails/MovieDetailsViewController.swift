import UIKit
import Movie_Wiki_Commons
import Movie_Wiki_Api
import Moya

class MovieDetailsViewController: BaseViewController {
    let viewModel: MovieDetailsViewModel
    
    init(provider: MoyaProvider<TheMovieDb>) {
        viewModel = MovieDetailsViewModel(provider: provider)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
