import Foundation
import Movie_Wiki_Commons
import Swinject

public class HomeCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public var childCoordinators = [Coordinator]()
    public var container: Container
    
    public init() {
        navigationController = UINavigationController()
        container = HomeDependencies().container
    }
    
    public func start() {
        guard let homeViewController = container.resolve(HomeViewController.self) else { return }
        navigationController.setViewControllers([homeViewController], animated: false)
    }
}
