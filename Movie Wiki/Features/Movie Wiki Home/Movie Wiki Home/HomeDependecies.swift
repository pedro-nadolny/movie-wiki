import Foundation
import Swinject

class HomeDependencies {
    
    let container = Container()
    
    init() {
        registerServices()
        registerHomeScene()
        registerMovieDetailsScene()
    }
    
    fileprivate func registerServices() {
        
    }
    
    fileprivate func registerHomeScene() {
        container.register(HomeViewController.self) { _ in HomeViewController() }
    }
    
    fileprivate func registerMovieDetailsScene() {
        container.register(MovieDetailsViewController.self) { _ in MovieDetailsViewController() }
    }
}
