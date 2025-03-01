final class ReviewsScreenFactory {

    func makeReviewsViewModel() -> ReviewsViewModel {
        let reviewsProvider = ReviewsProvider()
        return ReviewsViewModel(reviewsProvider: reviewsProvider)
    }
    
    func makeReviewsController(viewModel: ReviewsViewModel) -> ReviewsViewController {
        return ReviewsViewController(viewModel: viewModel)
    }

}
