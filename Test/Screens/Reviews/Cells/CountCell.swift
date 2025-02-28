import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct CountCellConfig {
    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: CountCellConfig.self)
    
    /// Общее количество отзывов
    let totalReviews: NSAttributedString
}

// MARK: - TableCellConfig

extension CountCellConfig: TableCellConfig {
    func update(cell: UITableViewCell) {
        guard let cell = cell as? CountCell else { return }
        cell.countLabel.attributedText = totalReviews
    }
    
    func height(with size: CGSize) -> CGFloat {
        return 40
    }
}

// MARK: - Ячейка отображения количества отзывов

final class CountCell: UITableViewCell {
    // MARK: - UI Components
    fileprivate let countLabel = UILabel()
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    // MARK: - Setup
    private func setupCell() {
        contentView.addSubview(countLabel)
        countLabel.textAlignment = .center
        countLabel.numberOfLines = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        countLabel.frame = contentView.bounds
    }
}
