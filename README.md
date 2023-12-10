## ImageFeed

Многостраничное приложение предназначено для просмотра изображений через API Unsplash.

## **Скриншоты**

<img width="433" alt="Снимок экрана 2023-12-10 в 20 52 57" src="https://github.com/vadamask/ImageFeed/assets/53489821/ecc780bd-d440-49fa-aa4f-e00363d0f8d6">
<img width="429" alt="Снимок экрана 2023-12-10 в 20 54 14" src="https://github.com/vadamask/ImageFeed/assets/53489821/fff26fca-ad22-4f95-a804-e9e80f1fedd9">
<img width="433" alt="Снимок экрана 2023-12-10 в 20 55 36" src="https://github.com/vadamask/ImageFeed/assets/53489821/27612866-d6ea-4b16-8046-ca6381b44794">
<img width="427" alt="Снимок экрана 2023-12-10 в 20 54 19" src="https://github.com/vadamask/ImageFeed/assets/53489821/3f07d8ae-731c-4541-8ec9-b4221c47e866">
<img width="429" alt="Снимок экрана 2023-12-10 в 20 54 23" src="https://github.com/vadamask/ImageFeed/assets/53489821/ba38a3ce-4619-481f-875b-6ad2de39bbe7">


## Инструкция

Приложение готово к использованию после скачивания, но только после обязательной авторизации через Unsplash. Главный экран состоит из ленты с изображениями, пользователь может просматривать ее, добавлять и удалять изображения из избранного. Можно просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения. У пользователя есть профиль с избранными изображениями и краткой информацией о себе.

Важно! Из-за платных ограничений со стороны API, количество запросов в сеть ограничено до 50 в час. Если вдруг приложение выдаст алерт с ошибкой, то скорее всего именно из-за этого.

## Технические требования

- Поддержка устройств iPhone начиная с iOS 13, предусмотрен только портретный режим
- вёрстка под iPad не предусмотрена

Стек: UITableView, ScrollView, WebView, KVO, SPM, Kingfisher, CoreAnimation, MVP, URLSession

## **Ссылки**

- [Дизайн в Figma](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP))
- [Unsplash API](https://unsplash.com/documentation)
