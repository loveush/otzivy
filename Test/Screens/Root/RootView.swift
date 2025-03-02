import UIKit

final class RootView: UIView {

    private let reviewsButton = UIButton(type: .system)
    private let onTapReviews: () -> Void

    private let loadingIndicator = CustomIndicatorView()
    
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
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - Private

private extension RootView {

    func setupView() {
        backgroundColor = .systemBackground
        setupReviewsButton()
        setupLoadingIndicator()
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
    
    /// Индиктор загрузки
    func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.isHidden = true
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: reviewsButton.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: reviewsButton.bottomAnchor, constant: 30),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
