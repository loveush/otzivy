import UIKit

final class RootViewController: UIViewController {

    private lazy var rootView = RootView(onTapReviews: openReviews)
    
    override func loadView() {
        view = rootView
    }

}

// MARK: - Private

private extension RootViewController {

    private func openReviews() {
        let factory = ReviewsScreenFactory()
        let viewModel = factory.makeReviewsViewModel()

        /// Подписываемся на изменения загрузки
        viewModel.onLoadingChange = { [weak self] isLoading in
            self?.rootView.showLoadingIndicator(isLoading)
        }
        
        viewModel.getReviews()
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                let controller = factory.makeReviewsController(viewModel: viewModel)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

}
