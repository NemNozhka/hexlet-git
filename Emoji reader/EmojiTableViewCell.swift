//
//  EmojiTableViewCell.swift
//  Emoji reader
//
//  Created by Сергей Ножка on 09.10.2022.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() { //метод срабатывает когда ячейка прогрузится
        super.awakeFromNib()
    }
//MARK: - настройка каждой ячейка
    //object это массив наших emoji находиться в EmojiClass
    func set(object: Emoji) {
        self.nameLabel.text = object.name
        self.emojiLabel.text = object.emoji
        self.descriptionLabel.text = object.description
    }

}
