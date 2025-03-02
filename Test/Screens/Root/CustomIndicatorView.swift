import UIKit

class CustomIndicatorView: UIView {
    
    /// Основная точка
    private let dotLayer = CAShapeLayer()
    
    /// Параметры анимации
    private let dotRadius: CGFloat = 6.0
    private let animationDuration: CFTimeInterval = 1.2
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupDot() {
        let dotPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: dotRadius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        
        dotLayer.path = dotPath.cgPath
        dotLayer.fillColor = UIColor.showMore.cgColor
        dotLayer.strokeColor = UIColor.clear.cgColor
        
        layer.addSublayer(dotLayer)
    }
    
    // MARK: - Animation
    
    func startAnimating() {
        /// Анимация вращения точки по окружности
        let orbit = CAKeyframeAnimation(keyPath: "position")
        orbit.path = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: bounds.width - dotRadius*2, 
            startAngle: -.pi/2,
            endAngle: 3 * .pi/2,
            clockwise: true
        ).cgPath
        orbit.duration = animationDuration
        orbit.repeatCount = .infinity
        orbit.calculationMode = .paced
        
        /// Дополнительная анимация пульсации
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.6
        scaleAnimation.duration = animationDuration/2
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        
        dotLayer.add(orbit, forKey: "orbit")
        dotLayer.add(scaleAnimation, forKey: "scale")
    }
    
    func stopAnimating() {
        dotLayer.removeAllAnimations()
    }
}
