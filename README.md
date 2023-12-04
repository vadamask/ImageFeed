## ImageFeed

Многостраничное приложение предназначено для просмотра изображений через API Unsplash.

## Инструкция

Приложение готово к использованию после скачивания, но только после обязательной авторизации через Unsplash. Главный экран состоит из ленты с изображениями, пользователь может просматривать ее, добавлять и удалять изображения из избранного. Можно просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения. У пользователя есть профиль с избранными изображениями и краткой информацией о себе.

Важно! Из-за платных ограничений со стороны API, количество запросов в сеть ограничено до 50 в час. Если вдруг приложение выдаст алерт с ошибкой, то скорее всего именно из-за этого.

## Технические требования

- Поддержка устройств iPhone начиная с iOS 13, предусмотрен только портретный режим
- вёрстка под iPad не предусмотрена

Стек: UITableView, ScrollView, WebView, KVO, SPM, Kingfisher, CoreAnimation, MVP, URLSession
