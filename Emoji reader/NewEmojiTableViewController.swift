//
//  NewEmojiTableViewController.swift
//  Emoji reader
//
//  Created by Сергей Ножка on 22.10.2022.
//

import UIKit

class NewEmojiTableViewController: UITableViewController {
    
    var emoji = Emoji(emoji: "", name: "", description: "", isFavourite: false)
    
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        updateSaveButtonState() //в первом случае метод будет срабатывать когда загружается экран
        
    }
    
    //MARK: - кнопка Save логика ее работы
    private func updateSaveButtonState() {
        let emojiText = emojiTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let discriptionText = descriptionTextField.text ?? ""
        
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !discriptionText.isEmpty //кнопка save будет доступна (enabled) если текстовые поля(textField) emojiText, nameText, discriptionText не будут пустые
    }
    
    private func updateUI() { //функция обновления интерфейса
        emojiTextField.text = emoji.emoji
        nameTextField.text = emoji.name
        descriptionTextField.text = emoji.description
    }
    
    @IBAction func textChange(_ sender: UITextField) { //данный экшен содержит в себе все три text Field (emoji, name, discription)
        updateSaveButtonState()
    }
    
    //MARK: - кнопка Save, передача данных в новый emoji
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //данная функция будет срабатывать при использовании segue(переход) перемещение со второго экрана на первый
        super.prepare(for: segue, sender: sender) //переопределии родительский класс
        guard segue.identifier == "saveSegue" else { return } //если индификатор равен указанному то мы идем дальше
        let emoji = emojiTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let discription = descriptionTextField.text ?? ""
        
        self.emoji = Emoji(emoji: emoji, name: name, description: discription, isFavourite: self.emoji.isFavourite) //передали новые данные
    }
    
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */
    //данные методы нужны если мы разрабатываем динамический контент

    
}
