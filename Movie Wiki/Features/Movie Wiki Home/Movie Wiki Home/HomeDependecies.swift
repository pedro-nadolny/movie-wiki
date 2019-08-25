import Foundation
import Swinject
import Movie_Wiki_Api
import Moya

class HomeDependencies {
    let container = Container()
    
    init() {
        registerProviders()
        registerUpcomingScene()
        registerMovieDetailsScene()
    }
    
    fileprivate func registerProviders() {
        container.register(MoyaProvider<TheMovieDb>.self) { _ in MoyaProvider<TheMovieDb>.theMovieDb }
    }
    
    fileprivate func registerUpcomingScene() {
        container.register(UpcomingViewController.self) { _ in
            let provider = self.container.resolve(MoyaProvider<TheMovieDb>.self)!
            return UpcomingViewController(provider: provider)
        }
    }
    
    fileprivate func registerMovieDetailsScene() {
        container.register(MovieDetailsViewController.self) { _ in
            let provider = self.container.resolve(MoyaProvider<TheMovieDb>.self)!
            return MovieDetailsViewController(provider: provider)
        }
    }
}
