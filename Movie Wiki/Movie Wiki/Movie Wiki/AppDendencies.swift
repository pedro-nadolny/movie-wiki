import Foundation
import Swinject
import Movie_Wiki_Home

class AppDependencies {
    let container = Container()
    
    init() {
        registerCoordinators()
    }
    
    fileprivate func registerCoordinators()  {
        container.register(HomeCoordinator.self) { _ in HomeCoordinator() }
    }
}
