import UIKit

final class ReviewsViewController: UIViewController {

    // MARK: - Private properties
    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    // MARK: - Initializers
    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override funcs
    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        return reviewsView
    }
    
    func setupBindings() {
        /// Обновление отзывов при pull-to-refresh
        reviewsView.onRefresh = { [weak self] in
            self?.viewModel.refreshReviews()
        }
        
        /// Setup viewModel
        viewModel.onStateChange = { [weak self] _ in
            DispatchQueue.main.async {
                self?.reviewsView.tableView.reloadData()
                self?.reviewsView.tableView.refreshControl?.endRefreshing()
            }
        }
    }

}
