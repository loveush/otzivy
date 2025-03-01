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
        /// Сразу показываем индикатор
        rootView.showLoadingIndicator(true)
        
        DispatchQueue.main.async {
            let factory = ReviewsScreenFactory()
            let viewModel = factory.makeReviewsViewModel()
            
            /// Подписываемся на обновления состояния загрузки для управления индикатором
            viewModel.onLoadingChange = { [weak self] isLoading in
                self?.rootView.showLoadingIndicator(isLoading)
            }
            
            let controller = factory.makeReviewsController(viewModel: viewModel)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }

}
