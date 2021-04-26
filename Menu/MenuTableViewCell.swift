//
//  MenuTableViewCell.swift
//  Menu
//
//  Created by 1111 on 22.03.21.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var promotionPicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var attention: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var parameter1: UIButton!
    @IBOutlet weak var parameter2: UIButton!
    
    @IBOutlet weak var additionalProducts: UIView!
    

  
    var productsInCell = [Product]()
    var productInCell = Product()
    var showPopUpVC: ((_ viewConroller: UIViewController) -> ())!
    
    var callProduct : ((_ product : (Product)) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        parameter1.addTarget(self, action: #selector (parameter1Action), for: .touchUpInside)
        parameter2.addTarget(self, action: #selector (parameter2Action), for: .touchUpInside)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    
    @objc func parameter1Action (sender : UIButton){
        let productSelect1 = productsInCell.filter{ ($0.selectionButton1 != "") }   // читаем есть ли у продукта параметры для выбора
        let selectParameters = productSelect1.map({"\($0.selectionButton1)"})      // создаем масиив параметров для выбора
        let uniqueSelectParameters = uniqueParameter(source: selectParameters)    // из массива параметров выбираем уникальные параметры
        
        print(selectParameters)
        print(uniqueSelectParameters)
 
        if uniqueSelectParameters.isEmpty{
            print ("нет параметров для выбора")
        } else{
            popOverSelectingParameters(parameterNumber: 1, products: productsInCell, parameters: uniqueSelectParameters, previosParameter: productInCell.selectionButton1)
        }
    }
    
    
    @objc func parameter2Action (sender : UIButton){
        let productSelect1 = productsInCell.filter{ ($0.selectionButton1 == self.productInCell.selectionButton1) } // создаем массив продуктов, который подходит по первому параметру
        let productSelect2 = productSelect1.filter{ ($0.selectionButton2 != "") } // убираем нулевые жлементы массива
        let selectParameters = productSelect2.map({"\($0.selectionButton2)"})
        let uniqueSelectParameters = uniqueParameter(source: selectParameters)
        
        print(selectParameters)
        print(uniqueSelectParameters)
 
        if uniqueSelectParameters.isEmpty{
            print ("нет параметров для выбора")
        } else{
            popOverSelectingParameters(parameterNumber: 2, products: productsInCell, parameters: uniqueSelectParameters, previosParameter: productInCell.selectionButton2)
        }
    }
    
    
    
    
    
    
    // Mark: запуск таблицы выбора запускаем вызов таблицы с выбором параметров, возвразаем название первого параметра
    func popOverSelectingParameters(parameterNumber: Int,products: [Product], parameters : [String], previosParameter : String?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(identifier: "SelectingParameterVC") as! SelectingParameterViewController
    
        popVC.previosParameter = previosParameter ?? ""
        popVC.parameters = parameters

        popVC.selectedParameter1 = {(parameter: String) in
            var product = self.productsInCell
            if parameterNumber == 1 {
                product = product.filter{ ($0.selectionButton1.contains(parameter)) }
            }
            if parameterNumber == 2 {
                product = product.filter{ ($0.selectionButton1.contains(self.productInCell.selectionButton1))}
                product = product.filter{ ($0.selectionButton2.contains(parameter)) }
            }
            
            self.changeProductInCell(product: product[0], append: false)
            print("кол-во продуктов c выбранным параметром")
            print(product.count)
            print(product.map({"\($0.price)"}) )
        }
        popVC.modalPresentationStyle = .popover
        popVC.modalTransitionStyle = .crossDissolve
            self.showPopUpVC!(popVC)

    }
    
    
    
    

    

    @IBAction func BasketButton(_ sender: Any) {
        //при нажатии на кнопку покупка отправляется товар в корзину
        //меняем вид кнопки на кнопку - + и кол-во продуктов
    }
    
    func changeProductInCell(product: Product,append : Bool){
        fillingCell(product: product, append: append)
        callProduct!(product)
    }
    
    func fillingCell(product: Product) {

        
        self.productInCell = product
        
        name.text = product.name
        if !product.attention.isEmpty {
            attention.text = product.attention
        } else {
            attention.heightAnchor.constraint(equalToConstant: 0).isActive = true
            attentionTop.constant = 0
        }
        if !product.description.isEmpty {
            productDescription.text = product.description
        } else {
            productDescription.heightAnchor.constraint(equalToConstant: 0).isActive = true
            descriptionTop.constant = 0
        }
        if !product.parameter1.isEmpty {
            parameters.text = product.parameter1
            if !product.parameter2.isEmpty {
                parameters.text = parameters.text! + ", " + product.parameter2
            }
        } else {
            parameters.heightAnchor.constraint(equalToConstant: 0).isActive = true
            parapetersTop.constant = 0
        }
        if productInBasket.additionalProductCount > 0 {
            additionalProducts.text = "Добавлено \(productInBasket.additionalProductCount)x \(String(product.additionalProducts))"
        } else {
            additionalProducts.heightAnchor.constraint(equalToConstant: 0).isActive = true
            additionalProductsTop.constant = 0
        }
        
        
       
       
        price.text = String(product.price) + " руб."
        if !product.weight.contains("мл") {
            weight.text = product.weight + " гр"
        } else {
            weight.text = product.weight
        }
        
        var count = productInBasket.productCount
        
        let basketButton = BasketButton(frame: CGRect(x: 1, y: 1, width: basketButtonView.frame.width - 2, height: basketButtonView.frame.height - 2))
        basketButton.configure(count: count)
        basketButton.callbackCount = {(callbackCount : Int) in
            count = callbackCount
            self.productInCell.productCount = count
            print(product.name + "   :" + String(count))
            if self.callbackProductInCell != nil {
                self.callbackProductInCell!(self.productInCell)
            }
        }
        basketButtonView.backgroundColor = .none
        basketButtonView.addSubview(basketButton)
        basketButton.translatesAutoresizingMaskIntoConstraints = false
//        basketButton.leadingAnchor.constraint(equalTo: basketButtonView.leadingAnchor).isActive = true
//        basketButton.topAnchor.constraint(equalTo: basketButtonView.topAnchor).isActive = true
//        basketButton.bottomAnchor.constraint(equalTo: basketButtonView.bottomAnchor).isActive = true
//        basketButton.trailingAnchor.constraint(equalTo: basketButtonView.trailingAnchor).isActive = true
    }
    
    
}
    
    
    
}
