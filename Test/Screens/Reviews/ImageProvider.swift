
import UIKit

/// Класс для загрузки фото отзывов.
final class ImageProvider {

    /// Синглтон экземпляр
    static let shared = ImageProvider()
    private var cache = NSCache<NSString, UIImage>()

    private init() {}

    /// Метод для загрузки фото.
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        
        /// Проверка кэша
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }

        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }

        /// Асинхронная загрузка изображенний через URLSession
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
