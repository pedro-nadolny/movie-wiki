import Foundation
import Movie_Wiki_Commons
import Movie_Wiki_Home
import Swinject

class AppCoordinator: Coordinator {
    let window: UIWindow?
    var container: Container
    public var childCoordinators = [Coordinator]()
    
    init(window: UIWindow?) {
        self.window = window
        container = AppDependencies().container
    }
    
    func start() {
        guard
            let window = window,
            let homeCoordinator = container.resolve(HomeCoordinator.self)
        else { return }
        
        homeCoordinator.start()
        window.rootViewController = homeCoordinator.navigationController
        window.makeKeyAndVisible()
    }
}
