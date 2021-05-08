//
//  ProductViewController.swift
//  Menu
//
//  Created by 1111 on 3.04.21.
//

import UIKit



class ProductViewController: UIViewController {
    var index = Int()
    var productsInCell = [Product]()
    var productInCell = Product()
    var showPopUpVC: ((_ viewConroller: UIViewController) -> ())!
    var productCount = 0
    var callbackProduct : ((_ product : (Product)) -> ())?
    
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var promotionPicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var attention: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var parameter1: UIButton!
    @IBOutlet weak var parameter2: UIButton!
    @IBOutlet weak var energyCalories: UILabel!
    @IBOutlet weak var energyFat: UILabel!
    @IBOutlet weak var energyProtein: UILabel!
    @IBOutlet weak var energyCarbohydrates: UILabel!
    @IBOutlet weak var additionalProductView: UIView!
    
    @IBOutlet weak var basketButtonView: BasketButton!
    
    
    // constraint
    
    @IBOutlet weak var attentionTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionTop: NSLayoutConstraint!
    @IBOutlet weak var parameter1Top: NSLayoutConstraint!
    @IBOutlet weak var parameter2Top: NSLayoutConstraint!
    @IBOutlet weak var additionalProductTop: NSLayoutConstraint!
    
    @IBOutlet weak var parameter1Height: NSLayoutConstraint!
    @IBOutlet weak var parameter2Height: NSLayoutConstraint!
    
    @IBOutlet weak var additionalProductHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        productView.layer.cornerRadius = 10
        
//        products =  products.filter{ ($0.name.contains(product.name)) }
        
        parameter1.addTarget(self, action: #selector (parameter1Action), for: .touchUpInside)
        buttonVisualSettings(button: parameter1)
        parameter2.addTarget(self, action: #selector (parameter2Action), for: .touchUpInside)
        buttonVisualSettings(button: parameter2)
        fillingVC(product: productInCell)
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
        let productSelect1 = productsInCell.filter{ ($0.parameter1 != "") }   // читаем есть ли у продукта параметры для выбора
        let selectParameters = productSelect1.map({"\($0.parameter1)"})      // создаем масиив параметров для выбора
        let uniqueSelectParameters = uniqueParameter(source: selectParameters)    // из массива параметров выбираем                                                                          // уникальные параметры
        if uniqueSelectParameters.isEmpty{
            print ("нет параметров для выбора")
        } else{
            popOverSelectingParameters(parameterNumber: 1, products: productsInCell, parameters: uniqueSelectParameters, previosParameter: productInCell.parameter1)
        }
    }


    @objc func parameter2Action (sender : UIButton){
        let productSelect1 = productsInCell.filter{ ($0.parameter1 == self.productInCell.parameter1) } // создаем массив продуктов, который подходит по первому параметру
        let productSelect2 = productSelect1.filter{ ($0.parameter2 != "") } // убираем нулевые элементы массива
        let selectParameters = productSelect2.map({"\($0.parameter2)"})
        let uniqueSelectParameters = uniqueParameter(source: selectParameters)

        print(selectParameters)
        print(uniqueSelectParameters)

        if uniqueSelectParameters.isEmpty{
            print ("нет параметров для выбора")
        } else{
            popOverSelectingParameters(parameterNumber: 2, products: productsInCell, parameters: uniqueSelectParameters, previosParameter: productInCell.parameter2)
        }
    }
    
    
    
    
    

    // MARK: запуск таблицы выбора запускаем вызов таблицы с выбором параметров, возвразаем название первого параметра
    func popOverSelectingParameters(parameterNumber: Int,products: [Product], parameters : [String], previosParameter : String?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(identifier: "SelectingParameterVC") as! SelectingParameterViewController

        popVC.previosParameter = previosParameter ?? ""
        popVC.parameters = parameters

        popVC.selectedParameter1 = {(parameter: String) in
            var product = self.productsInCell
            if parameterNumber == 1 {
                product = product.filter{ ($0.parameter1.contains(parameter)) }
            }
            if parameterNumber == 2 {
                product = product.filter{ ($0.parameter1.contains(self.productInCell.parameter1))}
                product = product.filter{ ($0.parameter2.contains(parameter)) }
            }
            self.changeProductInCell(product: product[0])
        }
        popVC.modalPresentationStyle = .popover
        popVC.modalTransitionStyle = .crossDissolve
        self.present(popVC, animated: true, completion: nil)

    }

    func changeProductInCell(product: Product){
        fillingVC(product: product)
        callbackProduct!(product)
    }
    
    
    
    func fillingVC(product : Product){

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

        energyFat.text = "Жиры - \(product.energyFat) г"
        energyProtein.text = "Белки - \(product.energyProtein) г"
        energyCarbohydrates.text = "Белки - \(product.energyCarbohydrates) г"
        energyCalories.text = "Энергетическкая ценность - \(product.energyCalories) ккал"

        if !product.parameter1.isEmpty {
            parameter1.setTitle(product.parameter1, for: .normal)
        } else {
            parameter1.isHidden = true
            parameter1Height.constant = 0
            parameter1Top.constant = 0
        }
        if !product.parameter2.isEmpty {
            parameter2.setTitle(product.parameter2, for: .normal)
        } else {
            parameter2.isHidden = true
            parameter2Height.constant = 0
            parameter2Top.constant = 0
        }
        if !product.additionalProducts.isEmpty {
           additionalProductView.backgroundColor = .yellow
        } else {
            additionalProductHeight.constant = 0
            additionalProductTop.constant = 0
        }


        price.text = String(product.price) + " руб."
        if !product.weight.contains("мл") {
            weight.text = product.weight + " гр"
        } else {
            weight.text = product.weight
        }


        let basketButton = BasketButton(frame: CGRect(x: 0, y: 0, width: basketButtonView.frame.width, height: basketButtonView.frame.height))
            basketButton.configure(count: productCount)
            basketButton.callbackCount = {(callbackCount : Int) in
                self.productCount = callbackCount
                self.operationWithBasket(product: self.productInCell, count: self.productCount)
                print(product.name + "   :" + String(self.productCount))
                if self.callbackProduct != nil {
                    self.callbackProduct!(self.productInCell)
                }
            }
            basketButton.backgroundColor = .none
            basketButtonView.addSubview(basketButton)

        
        
    }
    
    
    
    @IBAction func escap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func correct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let PopVC = storyboard.instantiateViewController(identifier: "productSettingVC") as! ProductSettingVC
        PopVC.product = productInCell
       // PopVC.index = index

        PopVC.modalPresentationStyle = .popover
        PopVC.modalTransitionStyle = .crossDissolve


        PopVC.dismissProductVC = {
            self.dismiss(animated: true, completion: nil)
        }
        present(PopVC, animated: true, completion: nil)
    }
    
    
    
    func operationWithBasket(product: Product, count: Int){
        let products = productsInBasket.map({$0.product})

        if products.contains(self.productInCell){
                for index in 0...productsInBasket.count-1 {
                    if productsInBasket[index].product == productInCell {
                        if count > 0 {
                        productsInBasket[index].productCount = count
                            break
                        } else {
                            productsInBasket.remove(at: index)
                            break
                        }
                    }
                }

        } else {
            let productToBasket = ProductInBasket(product: product, productCount: count)
            productsInBasket.append(productToBasket)
        }

        print("в корзине сейчас: \(productsInBasket.count) товаров")
        print(productsInBasket.map(({"\($0.product.name)  :  \($0.productCount)"})))
    }

    func buttonVisualSettings(button: UIButton){
        button.backgroundColor = .none
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.0   // толщина обводки
        button.layer.borderColor = (UIColor.blue.withAlphaComponent(0.2)).cgColor // цвет обводки
    }
    
}
