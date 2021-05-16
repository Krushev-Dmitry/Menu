//
//  BasketTableViewCell.swift
//  Basket
//
//  Created by 1111 on 9.04.21.
//

import UIKit

class BasketTableViewCell: UITableViewCell{


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var attention: UILabel!
    @IBOutlet weak var parameters: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var additionalProducts: UILabel!
    @IBOutlet weak var view: UIView!
        
    @IBOutlet weak var basketButtonView: UIView!
    @IBOutlet weak var delete: UIButton!
    
    // костыли!!!
    
    @IBOutlet weak var attentionTop: NSLayoutConstraint!
    @IBOutlet weak var parametersTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionTop: NSLayoutConstraint!
    @IBOutlet weak var additionalProductsTop: NSLayoutConstraint!
    
    
    
    
    var productInCell = ProductInBasket()
    var callbackProductInCell : (( _ productInCell: ProductInBasket) -> ())?
    var deleteCallBack : (() -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.05)
        view.layer.cornerRadius = 8
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowOpacity = 1
//        view.layer.shadowRadius = 10
//        view.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        delete.addTarget(self, action: #selector (deleteAction), for: .touchUpInside)
        
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func deleteAction(sender: UIButton){
        if deleteCallBack != nil {
        deleteCallBack!()
        }
    }
   
    
    
    
    func fillingCell(productInBasket: ProductInBasket) {

        parameters.removeConstraints(parameters.constraints)
        
        let product = productInBasket.product
        self.productInCell = productInBasket
        
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
            parametersTop.constant = 0
        }
//        if productInBasket.additionalProductCount > 0 {
//            additionalProducts.text = "Добавлено \(productInBasket.additionalProductCount)x \(String(product.additionalProducts))"
//        } else {
//            additionalProducts.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            additionalProductsTop.constant = 0
//        }
        
        
       
       
        price.text = String(product.price) + " руб."
        if !product.weight.contains("мл") {
            weight.text = product.weight + " гр"
        } else {
            weight.text = product.weight
        }
        
        var count = productInBasket.productCount

        let basketButton = BasketButton(frame: CGRect(x: 0, y: 0, width: basketButtonView.frame.width, height: basketButtonView.frame.height))
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

//        basketButton.leadingAnchor.constraint(equalTo: basketButtonView.leadingAnchor).isActive = true
//        basketButton.topAnchor.constraint(equalTo: basketButtonView.topAnchor).isActive = true
//        basketButton.bottomAnchor.constraint(equalTo: basketButtonView.bottomAnchor).isActive = true
//        basketButton.trailingAnchor.constraint(equalTo: basketButtonView.trailingAnchor).isActive = true
    }
    
    
}
