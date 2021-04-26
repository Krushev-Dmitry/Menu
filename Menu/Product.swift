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
    var name: String
    var description: String = ""
    var price: String = ""
    var weight: String = ""

    var picture: String = ""
    var promotionPicture: String = ""
    var energyCalories: String = ""
    var energyFat: String = ""
    var energyProtein: String = ""
    var energyCarbohydrates: String = ""
    var selectionButton1: String = ""
    var selectionButton2: String = ""
    var additionalProducts: String = ""
    
    init() {
        self.name = "без названия"
        self.category = "Pizza"
        self.price = ""
    }

}

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

