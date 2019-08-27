import Foundation
import Moya
import Movie_Wiki_Api
import Movie_Wiki_Assets
import RxCocoa
import RxSwift

class MovieDetailsViewModel {
    // MARK: - Dependecy Injection
    let provider: MoyaProvider<TheMovieDb>
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let isLoading: Driver<Bool>
    let movieTitle: Driver<String?>
    let movieOverview: Driver<String?>
    let movieRevenue: Driver<String?>
    let movieBudget: Driver<String?>
    let movieGenres: Driver<String?>
    let movieRuntime: Driver<String?>
    let movieVoteAverage: Driver<String?>
    let movieReleaseDate: Driver<String?>
    let movieBackdrop: Driver<UIImage?>
    let loadingError: Driver<Void>
    
    fileprivate let loadedMovie = PublishSubject<MovieDetails>()
    
    // MARK: - Inits
    init(provider: MoyaProvider<TheMovieDb>) {
        self.provider = provider
        
        isLoading = Driver.merge(
            loadedMovie.map { _ in false }.asDriver(onErrorJustReturn: false),
            Driver.of(true)
        ).asDriver(onErrorJustReturn: false)
        
        loadingError = loadedMovie
            .map { _ in false }
            .asDriver(onErrorJustReturn: true)
            .filter { $0 }
            .map { _ in } 
        
        movieBudget = loadedMovie
            .map { R.string.movieDetails.budgetPlaceholder(String($0.budget)) }
            .asDriver(onErrorJustReturn: nil)
        
        movieRevenue = loadedMovie
            .map { R.string.movieDetails.revenuePlaceholder(String($0.revenue)) }
            .asDriver(onErrorJustReturn: nil)
            .debug()
        
        movieTitle = loadedMovie
            .map { R.string.movieDetails.titlePlaceholder($0.title) }
            .asDriver(onErrorJustReturn: nil)
        
        movieOverview = loadedMovie
            .map { $0.overview }
            .asDriver(onErrorJustReturn: nil)
        
        movieRuntime = loadedMovie
            .map { R.string.movieDetails.runtimePlaceholder(String($0.runtime)) }
            .asDriver(onErrorJustReturn: nil)
        
        movieVoteAverage = loadedMovie
            .map { R.string.movieDetails.averagePlaceholder(String($0.voteAverage)) }
            .asDriver(onErrorJustReturn: nil)
        
        movieReleaseDate = loadedMovie
            .map { DateFormatter.yyyyMMdd.string(from: $0.releaseDate) }
            .map { R.string.movieDetails.releasePlaceholder($0) }
            .asDriver(onErrorJustReturn: nil)
        
        movieGenres = loadedMovie
            .flatMap { Observable.from($0.genres) }
            .map { $0.name }
            .reduce( nil as String? ) { result, value in
                guard let result = result else { return value }
                return R.string.movieDetails.commaSeparation(result, value)
            }
            .map { movieGenres in
                guard let movieGenres = movieGenres else { return nil }
                return R.string.movieDetails.genresPlaceholder(movieGenres)
            }
            .asDriver(onErrorJustReturn: nil)
        
        movieBackdrop = loadedMovie
            .map { $0.backdropPath }
            .flatMap { Observable.from(optional: $0) }
            .flatMap { provider.rx.request(.getBackdrop(file: $0)) }
            .mapImage()
            .map { $0 }
            .asDriver(onErrorJustReturn: nil)
    }
}

// MARK: - Public Methods
extension MovieDetailsViewModel {
    func bind(to movieIdDriver: Driver<Int>) {
        movieIdDriver
            .asObservable()
            .flatMap { self.provider.rx.request(.getMovie(id: $0)) }
            .map(MovieDetails.self, using: TheMovieDb.getMovie(id: 0).jsonDecoder, failsOnEmptyData: true)
            .bind(to: loadedMovie)
            .disposed(by: disposeBag)
    }
}

// MARK: - Private Methods
extension MovieDetailsViewModel {
    fileprivate func backdropDriver(for movieDetails: MovieDetails) -> Driver<Image?> {
        guard let backdropPath = movieDetails.backdropPath else { return Driver.of(nil) }
        
        return provider.rx
            .request(.getBackdrop(file: backdropPath))
            .mapImage()
            .map { $0 }
            .asDriver(onErrorJustReturn: nil)
    }
}
