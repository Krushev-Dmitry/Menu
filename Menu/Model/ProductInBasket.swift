//
//  ProductInBasket.swift
//  Menu
//
//  Created by 1111 on 4.05.21.
//

import Foundation

class ProductInBasket {
    var product = Product()
    var productCount = Int()
    
    init(product: Product, productCount: Int) {
        self.product = product
        self.productCount = productCount
    }
    
    init() {
        self.productCount = 0
    }
}
