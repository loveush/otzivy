import UIKit

final class RootView: UIView {

    private let reviewsButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let onTapReviews: () -> Void

    
    init(onTapReviews: @escaping () -> Void) {
        self.onTapReviews = onTapReviews
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Public API

extension RootView {
    func showLoadingIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Private

private extension RootView {

    func setupView() {
        backgroundColor = .systemBackground
        setupReviewsButton()
        setupActivityIndicator()
    }

    /// Кнопка "Отзывы"
    func setupReviewsButton() {
        reviewsButton.setTitle("Отзывы", for: .normal)
        reviewsButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        reviewsButton.addAction(UIAction { [unowned self] _ in onTapReviews() }, for: .touchUpInside)
        reviewsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        reviewsButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(reviewsButton)
        
        NSLayoutConstraint.activate([
            reviewsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reviewsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    /// Индикатор загрузки первого запроса отзывов
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: reviewsButton.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: reviewsButton.bottomAnchor, constant: 8)
        ])
    }

}
