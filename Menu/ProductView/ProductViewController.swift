//
//  ProductViewController.swift
//  Menu
//
//  Created by 1111 on 3.04.21.
//

import UIKit



class ProductViewController: UIViewController {
    
    var products = [Product]()
    var product = Product()
    var index = Int()
    
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var promotionPicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var parameter1: UIButton!
    @IBOutlet weak var parameter2: UIButton!
    @IBOutlet weak var energyCalories: UILabel!
    @IBOutlet weak var energyFat: UILabel!
    @IBOutlet weak var energyProtein: UILabel!
    @IBOutlet weak var energyCarbohydrates: UILabel!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        productView.layer.cornerRadius = 10
        
        products =  products.filter{ ($0.name.contains(product.name)) }
        
        parameter1.addTarget(self, action: #selector (button1Action), for: .touchUpInside)
        parameter1.layer.cornerRadius = 10
        parameter1.layer.borderWidth = 2.0   // толщина обводки
        parameter1.layer.borderColor = (UIColor.red.withAlphaComponent(0.2)).cgColor // цвет обводки

        parameter2.addTarget(self, action: #selector (button2Action), for: .touchUpInside)
        parameter2.layer.cornerRadius = 10
        parameter2.layer.borderWidth = 2.0   // толщина обводки
        parameter2.layer.borderColor = (UIColor.red.withAlphaComponent(0.2)).cgColor // цвет обводки
        
        fillingVC(product: product)
    }
    
    func uniqueParameter(source: [String]) -> [String] {
      var unique = [String]()
      for item in source {
        if !unique.contains(item) {
          unique.append(item)
        }
      }
      return unique
    }
    
    
    @objc func button1Action (sender : UIButton){

        let productSelect1 = products.filter{ ($0.parameter1 != "") }   // читаем есть ли у продукта параметры для выбора
        let selectParameters = productSelect1.map({"\($0.parameter1)"})      // создаем масиив параметров для выбора
        let uniqueSelectParameters = uniqueParameter(source: selectParameters)    // из массива параметров выбираем уникальные параметры
        
        print(selectParameters)
        print(uniqueSelectParameters)
 
        if uniqueSelectParameters.isEmpty{
            print ("нет параметров для выбора")
        } else{
            popOverSelectingParameters(parameterNumber: 1, products: products, parameters: uniqueSelectParameters, previosParameter: product.parameter1)
        }
    }
    
    
    @objc func button2Action (sender : UIButton){
        let productSelect1 = products.filter{ ($0.parameter1 == self.product.parameter1) } // создаем массив продуктов, который подходит по первому параметру
        let productSelect2 = productSelect1.filter{ ($0.parameter2 != "") } // убираем нулевые жлементы массива
        let selectParameters = productSelect2.map({"\($0.parameter2)"})
        let uniqueSelectParameters = uniqueParameter(source: selectParameters)
        
        print(selectParameters)
        print(uniqueSelectParameters)
 
        if uniqueSelectParameters.isEmpty{
            print ("нет параметров для выбора")
        } else{
            popOverSelectingParameters(parameterNumber: 2, products: products, parameters: uniqueSelectParameters, previosParameter: product.parameter2)
        }
    }
    
    
    
    
    
    
    // Mark: запуск таблицы выбора запускаем вызов таблицы с выбором параметров, возвразаем название первого параметра
    func popOverSelectingParameters(parameterNumber: Int,products: [Product], parameters : [String], previosParameter : String?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(identifier: "SelectingParameterVC") as! SelectingParameterViewController
    
        popVC.previosParameter = previosParameter ?? ""
        popVC.parameters = parameters

        popVC.selectedParameter1 = {(parameter: String) in
            var product = self.products
            if parameterNumber == 1 {
                product = product.filter{ ($0.parameter1.contains(parameter)) }
            }
            if parameterNumber == 2 {
                product = product.filter{ ($0.parameter1.contains(self.product.parameter1))}
                product = product.filter{ ($0.parameter2.contains(parameter)) }
            }
            self.product = product[0]
            self.fillingVC(product: product[0])
            print("кол-во продуктов c выбранным параметром")
            print(product.count)
            print(product.map({"\($0.price)"}) )
        }
        popVC.modalPresentationStyle = .popover
        popVC.modalTransitionStyle = .crossDissolve
        
        present(popVC, animated: true, completion: nil)

    }
    
    
    
    
    
    
    func fillingVC(product : Product){
        name.text = product.name
        descriptionProduct.text = product.description
        
        energyFat.text = "Жиры - \(product.energyFat) г"
        energyProtein.text = "Белки - \(product.energyProtein) г"
        energyCarbohydrates.text = "Белки - \(product.energyCarbohydrates) г"
        energyCalories.text = "Энергетическкая ценность - \(product.energyCalories) ккал"
         
        parameter1.setTitle(product.parameter1, for: .normal)
        parameter2.setTitle(product.parameter2, for: .normal)
        
        price.text = "\(product.price) руб"
        weight.text = "\(product.weight) гр"
    }
    
    
    
    @IBAction func escap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func correct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let PopVC = storyboard.instantiateViewController(identifier: "productSettingVC") as! ProductSettingVC
        PopVC.product = product
       // PopVC.index = index

        PopVC.modalPresentationStyle = .popover
        PopVC.modalTransitionStyle = .crossDissolve
        

        PopVC.dismissProductVC = {
            self.dismiss(animated: true, completion: nil)
        }
            
        present(PopVC, animated: true, completion: nil)
    }
}
