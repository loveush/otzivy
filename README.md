# Test
Тестовое задание в команду Рейтингов и Отзывов ВК.

## Что было выполнено:

- В ячейку отзывов добавлены аватар, имя пользователя и рейтинг.
- Добавлен обработчик нажатия на кнопку «Показать больше…».
- Фетчинг отзывов перенесен в фоновый поток GCD для плавного скролла.
- Добавлена ячейка CountCell в конфигурации TableCellConfig, отображающая количество отзывов.
- Реализована асинхронная загрузка изображений через URLSession с кэшированием в NSCache и многопоточностью через GCD.
- В ячейку отзыва добавлены фото, загружаемые асинхронно.
- Добавлен кастомный индикатор загрузки отзывов на первом экране, чтобы отображать процесс первого запроса отзывов.
- Добавлен Pull-to-refresh.
