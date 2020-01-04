//
//  ViewController.swift
//  apitTast
//
//  Created by Seif Yousry on 12/29/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwipeCellKit

class DataListViewController: UITableViewController {
    

    var dummyData  = [dataResults]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        netWorking()
        
    }
    sdsd
    
    //MARK:- NETWORK in Alamofire
     func netWorking() {
        let baseURL = "https://jsonplaceholder.typicode.com/posts"
        guard let finalURL = URL(string: baseURL) else { return }
        
        Alamofire.request(finalURL).responseJSON { (dataResponse) in
            if dataResponse.error != nil {
                print("failed to connect")
                return
            }
            guard let data = dataResponse.data else { return }
            
            do {
                let result = try JSONDecoder().decode([dataResults].self, from: data)
                
//                for i in 0..<result.count {
//                    print(result[i].userId ?? 0, result[i].id ?? 0, result[i].title, result[i].body)
//                }
                self.dummyData = result
                
                self.tableView.reloadData()
                
            }
                
            catch let decodeErroo {
                print("Faild to decode", decodeErroo)
            }
        }
    }
    
    
    struct dataResults: Decodable {
        let userId: Int?
        let id: Int?
        let title: String
        let body: String
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SwipeTableViewCell
        
        let dumData = self.dummyData[indexPath.row]
        cell.textLabel?.text = "useriD: \(dumData.userId ?? 0)\nid: \(dumData.id ?? 0)\ntitle: \(dumData.title)\nbody: \(dumData.body)"
        
        cell.textLabel?.numberOfLines = -1
        
        cell.delegate = self
        return cell
    }
    
    
    //MARK:- Add button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add data", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add the new data", style: .default) { (action) in
//            print("sucess")
            print(textField.text!)
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            let textField3 = alert.textFields![2] as UITextField
            let textField4 = alert.textFields![3] as UITextField
            

            
            self.dummyData.append(dataResults(userId: Int(textField.text ?? ""), id: Int(textField2.text ?? ""), title: textField3.text ?? "", body: textField4.text ?? ""))
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter userId"
            textField = alertTextField
            textField.textColor = .brown
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter id"
            alertTextField.textColor = .orange
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the title"
            alertTextField.textColor = .red
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter body"
            alertTextField.textColor = .green
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

//MARK:- Deleting
extension DataListViewController: SwipeTableViewCellDelegate {
         func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
    
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                print("Delete cell")
                
                self.dummyData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.reloadData()
            }
            
            return [deleteAction]
        }
}
