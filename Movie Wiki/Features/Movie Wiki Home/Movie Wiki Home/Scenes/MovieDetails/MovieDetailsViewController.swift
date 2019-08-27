import UIKit
import Movie_Wiki_Commons
import Movie_Wiki_Api
import Moya
import Cartography

class MovieDetailsViewController: BaseViewController {

    // MARK: - Layout
    let scroll = UIScrollView()
    let averageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    let budgetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    let revenueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    let backdropImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.startAnimating()
        return indicator
    }()
    let indicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        return view
    }()
    
    let viewModel: MovieDetailsViewModel
    
    init(provider: MoyaProvider<TheMovieDb>) {
        viewModel = MovieDetailsViewModel(provider: provider)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARk: - Life Cycle
extension MovieDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
}

// MARK: - Private Methods
extension MovieDetailsViewController {
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scroll)
        view.addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)
        scroll.addSubview(overviewLabel)
        scroll.addSubview(revenueLabel)
        scroll.addSubview(budgetLabel)
        scroll.addSubview(runtimeLabel)
        scroll.addSubview(releaseDateLabel)
        scroll.addSubview(averageLabel)
        scroll.addSubview(genresLabel)
        scroll.addSubview(backdropImageView)
        
        constrain(activityIndicator, indicatorContainer) { indicator, container in
            container.center == container.superview!.center
            indicator.edges == container.edges.inseted(by: 16)
        }
        
        constrain(scroll) { scroll in
            scroll.edges == scroll.superview!.edges
        }
        
        constrain(backdropImageView, overviewLabel) { image, overviewLabel in
            let superview = image.superview!
            
            
            image.leading == superview.leading
            image.trailing == superview.trailing
            image.top == superview.top
            image.width == superview.width
            
            image.bottom == overviewLabel.top - 16
            
            overviewLabel.bottom == superview.bottom
            overviewLabel.leading == superview.leading + 16
            overviewLabel.trailing == superview.trailing - 16
        }
    }
    
    fileprivate func setupBindings() {
        viewModel.movieTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.movieOverview
            .drive(overviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movieBudget
            .drive(budgetLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movieRevenue
            .drive(budgetLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movieReleaseDate
            .drive(releaseDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movieBackdrop
            .drive(backdropImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.movieGenres
            .drive(genresLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 }
            .drive(indicatorContainer.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

