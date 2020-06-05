//
//  GameViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 16/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    @IBOutlet weak var ivConsole: UIImageView!
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        lbTitle.text = game?.title
        lbConsole.text = game?.console?.name
        if let releaseDate = game?.releaseDate {
            let formatter = DateFormatter()
            // forçando usar o formato de data do Brasil
            // Note: procure fazer da forma de obter automaticamente do sistema
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
       
        if let image = game?.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
        
        if let image = game?.console?.image as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCoverFull")
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }
    

}
