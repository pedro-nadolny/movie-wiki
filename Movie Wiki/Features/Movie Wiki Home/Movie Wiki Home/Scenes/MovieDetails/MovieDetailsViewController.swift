import UIKit
import Movie_Wiki_Commons

class MovieDetailsViewController: BaseViewController {
    let viewModel: MovieDetailsViewModel
    
    override init() {
        viewModel = MovieDetailsViewModel()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
