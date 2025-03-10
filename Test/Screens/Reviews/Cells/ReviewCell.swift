import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Аватар пользователя.
    let avatarImage = UIImage(named: "emptyAvatar")
    /// Имя пользователя.
    let userName: NSAttributedString
    /// Рейтинг.
    let ratingImage: UIImage
    /// Фото отзыва.
    let photoUrls: [String]?
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void

    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        cell.avatarImageView.image = avatarImage
        cell.userNameLabel.attributedText = userName
        cell.ratingImageView.image = ratingImage
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        
        /// Удаляем все старые фото, чтобы при переиспользовании ячейки не было наложений
        cell.photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        /// Загружаем новые фото
        if let photoUrls = photoUrls {
            for url in photoUrls {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = ReviewCellLayout.photoCornerRadius
                imageView.clipsToBounds = true
                imageView.widthAnchor.constraint(equalToConstant: ReviewCellLayout.photoSize.width).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: ReviewCellLayout.photoSize.height).isActive = true
                
                /// Асинхронная загрузка
                ImageProvider.shared.loadImage(from: url) { image in
                    imageView.image = image
                }
                
                cell.photoStackView.addArrangedSubview(imageView)
            }
        }
        
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {
    // MARK: - Configuration
    fileprivate var config: Config?

    // MARK: - UI Components
    fileprivate let avatarImageView = UIImageView()
    fileprivate let userNameLabel = UILabel()
    fileprivate let ratingImageView = UIImageView()
    fileprivate let photoStackView = UIStackView()
    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()

    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    // MARK: - Override funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        
        avatarImageView.frame = layout.avatarImageViewFrame
        avatarImageView.layer.cornerRadius = ReviewCellLayout.avatarCornerRadius
        avatarImageView.clipsToBounds = true
        
        userNameLabel.frame = layout.userNameLabelFrame
        ratingImageView.frame = layout.ratingImageViewFrame
        photoStackView.frame = layout.photoStackViewFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
    }

}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setUpAvatar()
        setUpUserName()
        setUpRating()
        setupPhotoStackView()
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
    }
    
    func setUpAvatar() {
        contentView.addSubview(avatarImageView)

    }
    
    func setUpUserName() {
        contentView.addSubview(userNameLabel)
    }
    
    func setUpRating() {
        contentView.addSubview(ratingImageView)
    }
    
    func setupPhotoStackView() {
        photoStackView.axis = .horizontal
        photoStackView.spacing = 8.0
        photoStackView.alignment = .leading
        
        contentView.addSubview(photoStackView)
    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
        
        showMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
    }

}

// MARK: - Tap gestures

private extension ReviewCell {
    
    ///Обработчик нажатия на кнопку "Показать больше"
    @objc func showMoreTapped() {
        guard let config = config else { return }
        config.onTapShowMore(config.id)
    }
}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    fileprivate static let photoSize = CGSize(width: 55.0, height: 66.0)
    fileprivate static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы

    private(set) var avatarImageViewFrame = CGRect.zero
    private(set) var userNameLabelFrame = CGRect.zero
    private(set) var ratingImageViewFrame = CGRect.zero
    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero
    private(set) var photoStackViewFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        var maxY = insets.top
        var showShowMoreButton = false

        // MARK: - Аватар
        avatarImageViewFrame = CGRect(
            origin: CGPoint(x: insets.left, y: maxY),
            size: Self.avatarSize
        )
        
        /// Переменная, содержащая левую границу текста
        let minX = insets.left + avatarImageViewFrame.width + avatarToUsernameSpacing
        
        let width = maxWidth - minX - insets.right
        
        // MARK: - Имя пользователя
        userNameLabelFrame = CGRect(
            origin: CGPoint(x: minX, y: maxY),
            size: config.userName.boundingRect(width: width).size
        )
        maxY = userNameLabelFrame.maxY + usernameToRatingSpacing
        
        // MARK: - Звезды рейтинга
        ratingImageViewFrame = CGRect(
            origin: CGPoint(x: minX, y: maxY),
            size: config.ratingImage.size
        )
        
        // MARK: - Фото отзыва
        if let photoUrls = config.photoUrls, !photoUrls.isEmpty {
            maxY = ratingImageViewFrame.maxY + ratingToPhotosSpacing
            
            let totalWidth = CGFloat(photoUrls.count) * Self.photoSize.width + CGFloat(photoUrls.count - 1) * photosSpacing
            let photoX = minX
            photoStackViewFrame = CGRect(
                origin: CGPoint(x: photoX, y: maxY),
                size: CGSize(width: min(totalWidth, width), height: Self.photoSize.height)
            )
            maxY = photoStackViewFrame.maxY + photosToTextSpacing
        } else {
            maxY = ratingImageViewFrame.maxY + ratingToTextSpacing
            photoStackViewFrame = .zero
        }
        
        // MARK: - Текст отзыва
        if !config.reviewText.isEmpty() {
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: minX, y: maxY),
                size: config.reviewText.boundingRect(width: width, height: currentTextHeight).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        // MARK: - Показать больше
        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: minX, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        // MARK: - Когда оставлен отзыв
        createdLabelFrame = CGRect(
            origin: CGPoint(x: minX, y: maxY),
            size: config.created.boundingRect(width: width).size
        )

        return createdLabelFrame.maxY + insets.bottom
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
