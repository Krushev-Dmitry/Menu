//
//  PopOverViewController.swift
//  PopOver
//
//  Created by 1111 on 28.03.21.
//

import UIKit
 
class ProductSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
 
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var tableView: UITableView!
        

    var dismissProductVC: (() -> Void)!
    

    private var arrayOfCells: [Cell2TableViewCell] = []
  //  var selectedItemText: ((_ data: (String)) -> ())?
    var product = Product()
    var json = [String : Any]()

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            json = try product.toJson(excluding: ["id"])
            print(json)
        } catch { print("ошибка при формировоании json в productSettingVC")}
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.dataSource = self
        tableView.delegate = self
     
       // Apply radius to Popupview
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
 
    }
    
    
    // Returns count of items in tableView
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count;
    }
    
    
    //Assign values for tableView
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Cell2TableViewCell
        cell.label.text = " номер ячейки \(indexPath.row)"
//        cell.textField.placeholder = "sdfgvsdfgsd"
        let arrayKeys = Array(json.keys)
        let arrayValues = Array(json.values) as! [String]
        cell.label.text = arrayKeys[indexPath.row]
        if arrayValues[indexPath.row] != "" {
            cell.textField.text = arrayValues[indexPath.row]
        }else {
        cell.textField.placeholder = "введите значение"
        }
        cell.textField.delegate = self
        return cell
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? Cell2TableViewCell{
           
         /*   let index = tableView.indexPath(for: cell)?.row   // если нужен будет еще индекс ячейки */
            json.updateValue(cell.textField.text, forKey: cell.label.text!)
            print("внесли измения в \(cell.label.text!) =  \(cell.textField.text!)")
           
        }
        
    }

    
    
    // Close PopUp
    @IBAction func saveProduct(_ sender: Any) {
        if let id = product.id {
        APIManager.shared.updateProduct(productJson: json, id: id, in: "Products")
        }

        dismiss(animated: true)
        self.dismissProductVC()
    }
    
    @IBAction func createNewProduct(_ sender: Any) {
        APIManager.shared.createProduct(productJson: json)

        dismiss(animated: true, completion: nil)
        self.dismissProductVC()
    }
    
    
    
    
}
