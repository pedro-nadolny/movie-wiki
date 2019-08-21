import Foundation
import Swinject

public protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var container: Container { get set }
    func start()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
