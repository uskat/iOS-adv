
import UIKit

struct Post {
    public let id: UUID            //уникальный номер поста
    public let author: String      //автор публикации
    public var postDescription: String?//текст публикации
    public let imageName: String  //имя картинки из коллекции
    public var likes: Int32        //количество лайков у публикации
    public var views: Int32        //количество просмотров публикации

    init(id: UUID, author: String, postDescription: String, imageName: String, likes: Int32, views: Int32) {
        self.id = id
        self.author = author
        self.postDescription = postDescription
        self.imageName = imageName
        self.likes = likes
        self.views = views
    }
    
    static public func addPosts() -> [Post] {
        var post = [Post]()
        
        post.append(Post(id: UUID(), author: "Chupa-Chups", postDescription: "Восприятие управляет реальностью. Все проблемы во вселенной от того, что никто никому не помогает. Страх приведет к темной стороне. Страх рождает гнев; гнев рождает ненависть; ненависть — залог страданий.", imageName: "post0", likes: 100, views: 300))
        post.append(Post(id: UUID(), author: "Carbofos", postDescription: "Не сосредотачивайся на своих опасениях, Оби-Ван. Сконцентрируйся на том, что происходит сейчас и здесь.", imageName: "post1", likes: 110, views: 400))
        post.append(Post(id: UUID(), author: " Jean-Paul Belmondo", postDescription: "Стал ты силён и могуч Дуку, тёмную сторону я в тебе ощущаю. ", imageName: "post2", likes: 120, views: 500))
        post.append(Post(id: UUID(), author: "Donald Trump", postDescription:
                        """
                        Давным-давно в далёкой-далёкой галактике.. .
                        Война! Республика содрогается под атаками
                        безжалостного повелителя ситов, графа Дуку.
                        Герои сражаются на обеих сторонах.
                        Повсюду бедствия.
                        При поддержке армии сепаратистов жестокий
                        генерал Гривос проник в столицу республики
                        и похитил канцлера Палпатина -
                        лидера галактического сената.
                        Пока армия сепаратистов пытается скрыться
                        из окружённой столицы с ценным заложником,
                        2 рыцаря джедай выполняют задание
                        по спасению захваченного канцлера.. .
                        """,
                         imageName: "post3", likes: 130, views: 600))
        post.append(Post(id: UUID(), author: "T-1000", postDescription:
                        """
                         Штурмовик: Предъявите документы.
                         Оби Ван: Вам уже не нужны наши документы.
                         Штурмовик: Нам не нужны их документы.
                         Оби Ван: Это не те дроиды, что вы ищите.
                         Штурмовик: Это не те дроиды, что мы ищем.
                         Оби Ван: Надо его отпустить.
                         Штурмовик: Его надо отпустить.
                         Оби Ван Люку Скайуокеру: Проезжай.
                         Штурмовик: Проезжайте, проезжайте.
                        """,
                         imageName: "post4", likes: 140, views: 700))
        
        return post
    }
    
    static public func addFavorPosts() -> [Post] {
        var post = [Post]()
        
        post.append(Post(id: UUID(), author: "Вестник Императора", postDescription: "Восприятие управляет реальностью. Все проблемы во вселенной от того, что никто никому не помогает. Страх приведет к темной стороне. Страх рождает гнев; гнев рождает ненависть; ненависть — залог страданий.", imageName: "pic04", likes: 9900, views: 33300))
        return post
    }
}

