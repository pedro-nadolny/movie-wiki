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
        label.font = R.font.robotoItalic(size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    let averageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.robotoBold(size: 14)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.robotoBold(size: 11)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let posterFadeView: GradientView = {
        let view = GradientView()
        view.colors = [.clear, .black]
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        selectionStyle = .none
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
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(averageLabel)
        contentView.addSubview(posterFadeView)
        
        constrain(posterImageView, titleLabel, posterFadeView) { posterImageView, titleLabel, posterFadeView in
            let superview = posterImageView.superview!
            
            posterImageView.leading == superview.leading
            posterImageView.top == superview.top
            posterImageView.bottom == superview.bottom
            posterImageView.width == 154
            posterImageView.height == 274
            
            titleLabel.trailing == superview.trailing - 8
            titleLabel.top == superview.top + 8
            titleLabel.leading >= posterImageView.trailing + 8
            
            posterFadeView.trailing == posterImageView.trailing
            posterFadeView.width == 30
            posterFadeView.bottom == posterImageView.bottom
            posterFadeView.top == posterImageView.top
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
