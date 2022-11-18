//
//  EmojiClass.swift
//  Emoji reader
//
//  Created by Сергей Ножка on 08.10.2022.
//

import UIKit

class EmojiClass: UITableViewController {
    
    var object = [ //создали массив объектов EmojiModel
        Emoji(emoji: "😍", name: "Love", description: "Let's love each other", isFavourite: false),
        Emoji(emoji: "⚽️", name: "Football", description: "Let's play football together", isFavourite: false),
        Emoji(emoji: "🐱", name: "Cat", description: "Cat is the cutest animal", isFavourite: false)

    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Emoji Reader" //сделали заголовок
        self.navigationItem.leftBarButtonItem = self.editButtonItem //сделали кнопку слева на баре
    }
    
    //MARK: - добавление нового элемента
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! NewEmojiTableViewController //кастим segue через свойство source до типа NewEmojiTableViewController
        let emoji = sourceVC.emoji //достаем emoji из sourceVC по свойству emoji
       
        //если мы обращаемяс к существующему indexPath(т.е. кликаем по существующему emoji то существующий emoji изменяется, а не создается новый)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            object[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let newIndexPath = IndexPath(row: object.count, section: 0) // в данном случае мы приложение не крашится потому что новый элемент добавляется как нужно на последнее место по индексу
            object.append(emoji) //добавляем новый элемент в массив
           // let newIndexPath = IndexPath(row: object.count, section: 0) в данном случае мы добавляем элемент на несуществующее место потому строчка стоит(действие совершается) после того как добавили элемент т.е. на предпоследнее место по индексу, поэтому наше приложение крашится
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
        
    }

    //MARK: - редактирование существующих emoji
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = object[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Edit" //изменили title у второго экрана
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { //метод отвечающий за кол-во секций в таблице
        return 1 //секций у нас будет ОДНА
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //метод отвечающий за кол-во ячеек в одной секции
        return object.count //ячеек в секции будет столько же сколько элементов в нашем массиве object
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell //прокастиили ячейку для того что бы использовать соззданную нами кастомную ячейку со смайлом
        let object = object[indexPath.row] //достаем элемент по конктретной ячейке
        cell.set(object: object)
        return cell
        //это метод с помощью которогу будем настраивать ячейку
    }
    
    //MARK: - работа с элементами при нажатии кнопки "Edit"
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { //метод который в качестве выходного объекта возращает элемент который будет выден при нажатии кнопки Edit
        //если нам нужно delete то можно не писать данный метод потому что он по дефолту ставит там кнопку delete
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { //функция котора позволяет делать в зависимости от того что мы выбрали в функции выше delete(удалить) или insert(добавить)
        if editingStyle == .delete {
            object.remove(at: indexPath.row) //удаляем объект под тем индексом с которым работаем (удаляем тот объект на который ткнули)
            tableView.deleteRows(at: [indexPath], with: .fade) //удалем объект из tableView (ЭТО ОБЯЗАТЕЛЬНО!) под индексом который выбрали ("at:") с определенной  анимацией ("with:")
            
            //сейчас при удалении объекта мы не удаляем объект из памяти устройства, т.е. при перезапуске симулятора снова будет прежнее кол-во объектов в нашем списке
            //что бы удалять из памяти устройства нужно пройти курс CoreData там уже обучат как хранить и удалять данные в памяти устройства
        }
    }
    
    //MARK: - перетаскивание элементов
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true //метод который показывает клавишу для перетаскивание элементов в таблице
    }
   
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //sourceIndexPath это индекс с которого мы начали перетаскивать элемент
        //destinationIndexPath это индекс на который мы перетащили элемент
        let movedEmoji = object.remove(at: sourceIndexPath.row) //удалем объект с того индекса с которого начали перетаскивать
        object.insert(movedEmoji, at: destinationIndexPath.row) //добавляем удаленный элемент на тот индекс на который закончили перетаскивать
        tableView.reloadData() //обновили таблицу
    }
    
    //MARK: - кнопки при свайпе вправо
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { //метод который позволяет при свайпе вправо показывать различные кнопки(actions)
        let done = doneAction(at: indexPath) //сказали что есть у нас action done
        let favourite = favouriteAction(at: indexPath) //сказали что у нас есть action favourite
        return UISwipeActionsConfiguration(actions: [done, favourite])
        //возаращем actions (кнопки которые мы сделали), так как в качесвте возращаемого парамертра принимает массив то кнопок может быть множество
    }
    
    /*
     override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { //метод который позволяет при свайпе влево показывать различные кнопки(actions)
        <#code#>
    }
     */
    //MARK: - кнопка галочки при свайпе вправо
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
        //style это как ячейка будет возращаться на место (normal) или пропадать (destructive)
        //title в данном случае может быть какой угодно потому что заполнять будем изображением
            //handler прописываем что будет происходить при нажатии на action("Done")
            self.object.remove(at: indexPath.row) //обращаемся к объекту по индесу
            self.tableView.deleteRows(at: [indexPath], with: .automatic) //обращаемся к tableView, удаляем объект по текущему индексу с анимацией
            completion(true) //означает что на этом этапе действия заверешенно и никаких действий происходить не будет
        }
        action.backgroundColor = .systemGreen //цвет заливки action
        action.image = UIImage(systemName: "checkmark.circle.fill") //изображение action, если уберем это строчку то будет "Done" на зеленом фоне, но если есть изображение то оно просто перекрывает текст, в данном случае "Done"
        return action //возращаем кнопку
    }
    
    //MARK: - кнопка лайка(сердечко)
    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = object[indexPath.row] //добрались до объекта с которым взаимодействуем(кликаем)
        let action = UIContextualAction(style: .normal, title: "Favourite") { (action, view, completion) in
            object.isFavourite = !object.isFavourite //сделали обратный объект(перевернули), если был true станет false
            self.object[indexPath.row] = object //заменяем существующий объект на обновленный(перевернутый)
            completion(true)
        }
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray //если true то цвет фиолетовый, если нет то цвет gray
        action.image = UIImage(systemName: "heart")
        return action
    }
    
}
