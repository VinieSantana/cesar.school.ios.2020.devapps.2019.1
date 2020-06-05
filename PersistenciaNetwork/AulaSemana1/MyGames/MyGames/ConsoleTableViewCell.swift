//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by Vinicius on 28/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

    @IBOutlet weak var ivConsole: UIImageView!
    @IBOutlet weak var lbConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepare(with console: Console) {
        
        lbConsole.text = console.name ?? ""
        if let image = console.image as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCover")
        }
    }
}
