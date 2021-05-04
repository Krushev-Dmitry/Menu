//
//  SelectingParameterViewController.swift
//  Menu
//
//  Created by 1111 on 7.04.21.
//

import UIKit

class SelectingParameterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var previosParameter = String()
    var selectedParameter1: ((_ data: (String)) -> ())?
    var parameters =  [String]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tableView.dataSource = self
        tableView.delegate = self
     
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
     }
    
    override func viewWillLayoutSubviews() {
        tableView.frame.size.width = self.view.frame.width - 70
        tableView.frame.size.height = tableView.contentSize.height
        tableView.center = view.center
    }
    
    
    // Returns count of items in tableView
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parameters.count;
    }
    
    
    //Assign values for tableView
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
 
        if previosParameter.contains(parameters[indexPath.row]) {
            cell.textLabel?.text = "\u{25C9}" + "   " + parameters[indexPath.row]}
        else {
            cell.textLabel?.text = "\u{25CE}" + "   " + parameters[indexPath.row]
        }
        return cell
    }
    
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let parameter = parameters[indexPath.row]
        print("выбрали параметр : " + parameter)
        
        selectedParameter1!(parameter)
        dismiss(animated: true, completion: nil)
        
    }
    
}
