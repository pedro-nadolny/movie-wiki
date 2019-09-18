import Foundation
import Movie_Wiki_Api
import Movie_Wiki_Assets
import Movie_Wiki_Commons
import RxSwift
import RxCocoa
import Cartography

class UpcomingMovieCell: UITableViewCell {
    // MARK: - Properties
    fileprivate var disposeBag = DisposeBag()
    
    // MARK: - Layout
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    let averageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .right
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.textAlignment = .right
        return label
    }()
    
    let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell
    override func prepareForReuse() {
       disposeBag = DisposeBag()
    }
}

// MARK: - Public Methods
extension UpcomingMovieCell {
    func configure(with moviePreview: MoviePreview, image: Driver<UIImage?>) {
        titleLabel.text = moviePreview.title
        averageLabel.text = String(moviePreview.voteAverage)
        releaseDateLabel.text = DateFormatter.yyyyMMdd.string(from: moviePreview.releaseDate)
        image.drive(posterImageView.rx.image).disposed(by: disposeBag)
    }
}

// MARK: - Private Methods
extension UpcomingMovieCell {
    fileprivate func setupUI() {
        contentView.addSubview(container)
        container.addSubview(posterImageView)
        container.addSubview(titleLabel)
        container.addSubview(releaseDateLabel)
        container.addSubview(averageLabel)
        
        constrain(container) { container in
            container.edges == container.superview!.edges.inseted (
                top: 16,
                leading: 16,
                bottom: 0,
                trailing: 16
            )
        }
        
        constrain(posterImageView, titleLabel) { posterImageView, titleLabel in
            let superview = posterImageView.superview!
            let posterAspect: CGFloat = 16.0 / 9.0
            
            posterImageView.leading == superview.leading
            posterImageView.top == superview.top
            posterImageView.bottom == superview.bottom
            posterImageView.width == 154
            posterImageView.height == posterImageView.width * posterAspect
            
            titleLabel.trailing == superview.trailing - 8
            titleLabel.top == superview.top + 8
            titleLabel.leading >= posterImageView.trailing + 8
        }
        
        constrain(titleLabel, averageLabel, releaseDateLabel) { titleLabel, averageLabel, releaseDateLabel in
            align(trailing: titleLabel, averageLabel, releaseDateLabel)
            align(leading: titleLabel, averageLabel, releaseDateLabel)
            
            averageLabel.top == titleLabel.bottom + 16
            releaseDateLabel.top == averageLabel.bottom + 8
            releaseDateLabel.bottom <= releaseDateLabel.superview!.bottom + 8
        }
    }
}
