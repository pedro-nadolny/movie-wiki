import UIKit
import Movie_Wiki_Commons
import Movie_Wiki_Api
import Movie_Wiki_Assets
import Moya
import RxSwift
import RxCocoa
import Cartography

class UpcomingViewController: BaseViewController {
    let viewModel: UpcomingViewModel
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = 16
        
        let cell = UpcomingMovieCell.self
        tableView.register(cell, forCellReuseIdentifier: cell.description())
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.startAnimating()
        return indicator
    }()
    
    let indicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        return view
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    init(provider: MoyaProvider<TheMovieDb>) {
        let cellDisplayed = tableView.rx
            .didEndDisplayingCell
            .map { $1.row }
            .asDriver(onErrorJustReturn: 0)
        
        let cellSelected = tableView.rx
            .itemSelected
            .map { $0.row }
            .asDriver(onErrorJustReturn: -1)
        
        viewModel = UpcomingViewModel(provider, cellDisplayed, cellSelected)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension UpcomingViewController {
    override func viewDidLoad() {
        title = R.string.upcoming.screenTitle()
        
        setupUI()
        setupBindings()
        viewModel.loadNextPage.onNext(())
    }
}

// MARK: - Private Methods
extension UpcomingViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        view.addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)

        constrain(tableView) { tableView in
            tableView.edges == tableView.superview!.edges
        }
        
        constrain(activityIndicator, indicatorContainer) { indicator, container in
            container.center == container.superview!.center
            indicator.edges == container.edges.inseted(by: 16)
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        
        searchController.searchBar.placeholder = R.string.upcoming.searchBarPlaceholder()
    }
    
    fileprivate func setupBindings() {
        searchController.searchBar.rx
            .text
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 }
            .drive(indicatorContainer.rx.isHidden)
            .disposed(by: disposeBag)
        
        let cell = UpcomingMovieCell.self
        
        viewModel.moviesPreviews
            .drive(tableView.rx.items(cellIdentifier: cell.description(), cellType: cell)) { [weak self] _, item, cell in
                guard let self = self else { return }
                cell.configure(with: item, image: self.viewModel.posterDriver(for: item))
            }.disposed(by: disposeBag)
        
        viewModel.noMoviesFounds
            .drive(onNext: { [weak self] _ in
                self?.showAlert (
                    with: R.string.upcoming.noMoviesAlertTitle(),
                    and: R.string.upcoming.noMoviesAlertDescription()
                )
            })
            .disposed(by: disposeBag)
    }
}
