import Foundation
import Movie_Wiki_Api
import Moya
import RxSwift
import RxCocoa

class UpcomingViewModel {
    // MARK :- Injected Dependencies
    let provider: MoyaProvider<TheMovieDb>
    
    // MARK :- Properties
    let disposeBag = DisposeBag()
    let loadNextPage = PublishSubject<Void>()
    let searchText = PublishSubject<String?>()
    
    let moviesPreviews: Driver<[MoviePreview]>
    let isLoading: Driver<Bool>
    let noMoviesFounds: Driver<Void>
    let presentMovieDetails: Driver<Int>
    
    fileprivate let moviePreviewPages = BehaviorSubject(value: [MoviePreview.Page]())
    fileprivate let latestDisplayedMovieIndex = BehaviorSubject(value: 0)
    fileprivate let receivedNewPage: Observable<MoviePreview.Page>
    fileprivate let alreadyFetchedPages = BehaviorSubject(value: [Int]())
    
    init(_ provider: MoyaProvider<TheMovieDb>,_ cellDisplayed: Driver<Int>, _ cellSelected: Driver<Int>) {
        self.provider = provider

        // MARK: List Previews Bindings
        let loadedMoviePreviews = moviePreviewPages
            .map { $0.flatMap { $0.moviePreviews } }
        
        moviesPreviews = Observable
            .combineLatest(searchText, loadedMoviePreviews) {($0, $1)}
            .map { searchText, previews in
                guard let searchText = searchText, !searchText.isEmpty else { return previews }
                return previews.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
            .asDriver(onErrorJustReturn: [])
        
        receivedNewPage = loadNextPage
            .withLatestFrom(moviePreviewPages)
            .map { ($0.last?.page ?? 0) + 1 }
            .distinctUntilChanged()
            .flatMap { provider.rx.request(.getUpcomingMovies(page: $0)) }
            .map(MoviePreview.Page.self, using: TheMovieDb.getUpcomingMovies(page: 0).jsonDecoder, failsOnEmptyData: true)
            .asObservable()
        
        receivedNewPage
            .filter { $0.page <= $0.totalPages }
            .withLatestFrom(moviePreviewPages) { $1 + [$0] }
            .bind(to: moviePreviewPages)
            .disposed(by: disposeBag)
        
        // MARK: Pagination Bindings
        cellDisplayed
            .withLatestFrom(latestDisplayedMovieIndex.asDriver(onErrorJustReturn: Int.max)) {($0, $1)}
            .filter { $0 > $1 }
            .map { row, _ in row }
            .drive(latestDisplayedMovieIndex)
            .disposed(by: disposeBag)
        
        let latestDisplayedMovie = latestDisplayedMovieIndex
            .withLatestFrom(moviesPreviews) {($0, $1)}
            .filter { !$1.isEmpty }
            .map { index, movies in movies[index] }
        
        let flatMoviePreviewPages = moviePreviewPages
            .flatMap { Observable.from($0) }
            
        let latestDisplayedPage = latestDisplayedMovie
            .withLatestFrom(flatMoviePreviewPages)  {($0, $1)}
            .filter { $1.moviePreviews.contains($0) }
            .map { $1.page }
        
        let pageNumbers = flatMoviePreviewPages
            .map { $0.page }
        
        latestDisplayedPage
            .withLatestFrom(pageNumbers) {$0 == $1}
            .filter { $0 }
            .withLatestFrom(moviePreviewPages)
            .map { $0.last }
            .filter { ($0?.page ?? Int.max) < ($0?.totalPages ?? 0) }
            .map { _ in }
            .bind(to: loadNextPage)
            .disposed(by: disposeBag)
        
        // MARK: Loading Status Bindings
        isLoading = Observable.merge (
            loadNextPage.map { true },
            receivedNewPage.map { _ in false }
        ).asDriver(onErrorJustReturn: false)
        
        // MARK: No Data Bindings
        noMoviesFounds = isLoading
            .filter { !$0 }
            .withLatestFrom(moviesPreviews)
            .filter { $0.isEmpty }
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
        
        // MARK: Movie Selected Bindings
        self.presentMovieDetails = cellSelected
            .withLatestFrom(moviesPreviews) {($0, $1)}
            .map { index, movies in movies[index].id }
            .asDriver(onErrorJustReturn: -1)
    }
}

// MARK: - Public Methods
extension UpcomingViewModel {
    func posterDriver(for moviePreview: MoviePreview) -> Driver<Image?> {
        guard let posterPath = moviePreview.posterPath else { return Driver.of(nil) }
        
        return provider.rx
            .request(.getPoster(file: posterPath))
            .mapImage()
            .map { $0 }
            .asDriver(onErrorJustReturn: nil)
    }
}
