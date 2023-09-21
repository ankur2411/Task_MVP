//
//  JokeCell.swift
//  Assignment
//
//  Created by Ankur Verma on 20/09/23.
//

import UIKit

class JokeCell: UITableViewCell {
    
    @IBOutlet weak var lbl_dateTime: UILabel!
    @IBOutlet weak var lbl_joke: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(model:Joke){
        self.lbl_joke.text = model.joke
        if let jokeDate = model.jokeDate, let jokeTime = model.jokeTime{
            self.lbl_dateTime.text = jokeDate + " at " + jokeTime
        }
    }
}
