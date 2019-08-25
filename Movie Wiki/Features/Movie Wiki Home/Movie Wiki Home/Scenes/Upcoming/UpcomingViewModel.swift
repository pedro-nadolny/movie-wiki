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
    let loadNextPage: PublishSubject<Void>
    let moviesPreviews: Driver<[MoviePreview]>
    fileprivate let moviePreviewPages: BehaviorSubject<[MoviePreview.Page]>
    
    init(provider: MoyaProvider<TheMovieDb>) {
        moviePreviewPages = BehaviorSubject(value: [])
        loadNextPage = PublishSubject()
        self.provider = provider
    
        loadNextPage
            .withLatestFrom(moviePreviewPages)
            .flatMap { provider.rx.request(.getUpcomingMovies(page: ($0.last?.page ?? 0) + 1)) }
            .map(MoviePreview.Page.self, using: TheMovieDb.getUpcomingMovies(page: 0).jsonDecoder, failsOnEmptyData: true)
            .filter { $0.page <= $0.totalPages }
            .withLatestFrom(moviePreviewPages) { $1 + [$0] }
            .bind(to: moviePreviewPages)
            .disposed(by: disposeBag)
        
        moviesPreviews = moviePreviewPages
            .map { pages in pages.flatMap { page in page.moviePreviews } }
            .asDriver(onErrorJustReturn: [])
        
        loadNextPage.onNext(())
    }
}

extension UpcomingViewModel {
    func posterDriver(for moviePreview: MoviePreview) -> Driver<Image?> {
        guard let posterPath = moviePreview.posterPath else { return Driver.of(nil) }
        
        let call = TheMovieDb.getPoster(file: posterPath)
        return provider.rx
            .request(call)
            .mapImage()
            .map { $0 }
            .asDriver(onErrorJustReturn: nil)
    }
}
