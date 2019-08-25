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
    let button = UIButton()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .black
        tableView.separatorInset = .zero
        return tableView
    }()
    
    init(provider: MoyaProvider<TheMovieDb>) {
        viewModel = UpcomingViewModel(provider: provider)
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
    }
}

// MARK: - Private Methods
extension UpcomingViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        button.setTitle("Load more", for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

        constrain(tableView) { tableView in
            tableView.edges == tableView.superview!.edges
        }
        
        view.backgroundColor = .black
    }
    
    fileprivate func setupBindings() {
        setupTableView()
        
        button.rx.tap
            .bind(to: viewModel.loadNextPage)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupTableView() {
        let cell = UpcomingMovieCell.self
        tableView.register(cell, forCellReuseIdentifier: cell.description())
        
        viewModel
            .moviesPreviews
            .drive(tableView.rx.items(cellIdentifier: cell.description(), cellType: cell)) { [weak self] _, item, cell in
                guard let self = self else { return }
                cell.configure(with: item, image: self.viewModel.posterDriver(for: item))
            }
            .disposed(by: disposeBag)
    }
}
