//
//  Product.swift
//  Menu
//
//  Created by 1111 on 25.03.21.
//

import Foundation
import Firebase


//protocol Identifiable {
//    var id : String? {get set}
//}

struct Product : Codable, Identifiable{
    var id: String? = nil // 15  параметров с id
    var category: String
    var subCategory : String?
    var name: String
    var attention: String = ""
    var description: String = ""
    var price: Double
    var weight: String = ""
    var picture: String = ""
    var promotionPicture: String = ""
    var energyCalories: Int = 0
    var energyFat: Int = 0
    var energyProtein: Int = 0
    var energyCarbohydrates: String = ""
    var parameter1: String = ""
    var parameter2: String = ""
    var additionalProducts: String = ""
    
    init() {
        self.name = "без названия"
        self.category = "Pizza"
        self.price = 0
    }
    init(category: String, name: String, attention: String, description: String, price: Double, weight: String, parameter1: String, parameter2: String, additionalProducts : String){
    self.category = category
    self.name = name
    self.attention = attention
    self.description = description
    self.price = price
    self.weight = weight
//    self.picture = picture
//    self.promotionPicture = promotionPicture
//    self.energyCalories = energyCalories
//    self.energyFat = energyFat
//    self.energyProtein =energyProtein
//    self.energyCarbohydrates = energyCarbohydrates
    self.parameter1 = parameter1
    self.parameter2 = parameter2
    self.additionalProducts = additionalProducts
    }}

enum MyError : Error {
    case encodingError
}

extension Encodable{
    func toJson (excluding keys: [String] = [String]()) throws -> [String: Any]{
        let objectData = try JSONEncoder(   ).encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        
        guard var json = jsonObject as? [String: Any] else {throw MyError.encodingError}
    
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
}


extension Decodable{
    func fromJson (document: QueryDocumentSnapshot) throws -> Product?{
        do{
            var documentJson = document.data()
                documentJson["id"] = document.documentID
            let documentData = try JSONSerialization.data(withJSONObject: documentJson as Any, options: [])
            let product = try JSONDecoder().decode(Product.self, from: documentData)
            return (product)
        }
        catch {print(error)}
    return nil
    }

}

