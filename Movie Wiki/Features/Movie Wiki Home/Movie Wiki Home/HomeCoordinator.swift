import Foundation
import Movie_Wiki_Commons
import Swinject
import RxSwift
import RxCocoa

public class HomeCoordinator: Coordinator {
    public let navigationController: UINavigationController
    public var childCoordinators = [Coordinator]()
    public var container: Container
    
    let disposeBag = DisposeBag()
    let didAskToPresentMovieDetails = PublishSubject<Int>()
    
    public init() {
        navigationController = UINavigationController()
        container = HomeDependencies().container
        
        didAskToPresentMovieDetails
            .subscribe(onNext: { [weak self] id in
                self?.presentMovieDetails(with: id)
            })
            .disposed(by: disposeBag)
    }
    
    public func start() {
        let upcomingViewController = container.resolve(UpcomingViewController.self)!
        
        upcomingViewController.viewModel
            .presentMovieDetails
            .drive(didAskToPresentMovieDetails)
            .disposed(by: disposeBag)
        
        navigationController.setViewControllers([upcomingViewController], animated: false)
    }
    
    func presentMovieDetails(with id: Int) {
        let movieDetailsViewController = container.resolve(MovieDetailsViewController.self)!
        navigationController.pushViewController(movieDetailsViewController, animated: true)
        movieDetailsViewController.viewModel.bind(to: Driver.of(id))
    }
}
