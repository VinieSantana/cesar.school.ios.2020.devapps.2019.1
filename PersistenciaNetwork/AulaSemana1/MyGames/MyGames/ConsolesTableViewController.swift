//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 16/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import CoreData

class ConsolesTableViewController: UITableViewController {

    
    var fetchedResultController:NSFetchedResultsController<Console>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // se ocorrer mudancas na entidade Console, a atualização automatica não irá ocorrer porque nosso NSFetchResultsController esta monitorando a entidade Game. Caso tiver mudanças na entidade Console precisamos atualizar a tela com a tabela de alguma forma: reloadData :)
        loadConsoles()
    }
    
    func loadConsoles() {
        ConsolesManager.shared.loadConsoles(with: context)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ConsolesManager.shared.consoles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsoleTableViewCell
        
        let console = ConsolesManager.shared.consoles[indexPath.row]
        
        cell.prepare(with: console)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
//        let console = ConsolesManager.shared.consoles[indexPath.row]
//
        // deselecionar atual cell
        tableView.deselectRow(at: indexPath, animated: false)
     }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        ConsolesManager.shared.deleteConsole(index: indexPath.row, context: context)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "editConsole" {
            print("editConsole")
            let vc = segue.destination as! AddEditConsoleViewController
            
                vc.console = ConsolesManager.shared.consoles[tableView.indexPathForSelectedRow!.row]
        }
            
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
} // fim da classe
