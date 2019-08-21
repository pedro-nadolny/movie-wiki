import UIKit
import Movie_Wiki_Commons
import Cartography

class HomeViewController: BaseViewController {
    let viewModel: HomeViewModel
    
    override init() {
        viewModel = HomeViewModel()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController {
    override func viewDidLoad() {
        view.backgroundColor = .red
        
        let v = UIView()
        v.backgroundColor = .green
        view.addSubview(v)
        
        constrain(v) { v in
            if #available(iOS 11.0, *) {
                v.edges == v.superview!.safeAreaLayoutGuide.edges.inseted(by: 32)
            } else {
                v.edges == v.superview!.edges.inseted(by: 32)
            }
        }
    }
}
