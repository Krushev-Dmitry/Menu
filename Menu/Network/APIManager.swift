//
//  APIManager.swift
//  Menu
//
//  Created by 1111 on 28.03.21.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class  APIManager  {
    
    static let shared = APIManager()
   
    
    private func configureFB() -> Firestore {
        
        var db: Firestore
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        return db
    }
    
    
    func readProduct(collection: String, completion: @escaping ([Product]) -> Void ) {
        let db = configureFB()
        db.collection(collection).addSnapshotListener{(snapshot, _) in
            guard let snapshot = snapshot else {return}
            do {
                var products = [Product]()
                for document in snapshot.documents{
                    if let product = try Product().fromJson(document: document){
                    products.append(product)
                    }
                }
                completion(products)
            } catch {print("ошибка при чтении данных")}
        }
    }
    
    func readProduct(collection: String, id: String, completion: @escaping (Product?) -> Void ) {
        let db = configureFB()
        db.collection(collection).document(id).getDocument {(snapshot, _) in
            guard let document = snapshot else {return}
            do {
                let product = try Product().fromJson(document: document as! QueryDocumentSnapshot)
                completion(product)
            } catch {print("ошибка при чтении данных")}
        }
    }
    
        
        
        
        
    func createProduct (for product: Product, in collection: String){
        let db = configureFB()
        do {
            let json = try product.toJson(excluding: ["id"])
            db.collection(collection).addDocument(data: json)
            print(json)
        } catch  {
            print(error)
        }
        
    }
        
    func createProduct (productJson: [String : Any]){
        let db = configureFB()
        db.collection("Products").addDocument(data: productJson)
    }
                    
                    
 
        
    func updateProduct(product: Product, in collection: String){
        let db = configureFB()
        do {
            print("  в блоке update")
        //    let doc = try JSONEncoder().encode(product)
            let json = try product.toJson(excluding: ["id"])
            if let id = product.id {
            db.collection("Products").document(id).setData(json)
            print(json)
            } else {print("ошибка в получении ID")}
        } catch  {
            print(error)
        }
    }
    
    func updateProduct(productJson: [String : Any], id: String, in collection: String){
        let db = configureFB()
        db.collection(collection).document(id).setData(productJson)
    }
    
    
    
    
    
/*
        func delete<T: Identifiable>(_ identifiableObject: T, in collectionReference: FIRCollectionReference) {
            do {
               
                guard let id = identifiableObject.id else {throw MyError.encodingError}
                referencae(to: .users).document(id).delete()
            } catch  {
                print(error)
            }
*/



        
        
        
        
        
        
        
/* загрузка картинок из storage
    func getImage(picName: String, completion: @escaping (UIImage) -> Void)  {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathRef = reference.child("pictrures")
        
        var image: UIImage = UIImage (named: "default_pic")!
        
        let fileRef = pathRef.child(picName + ".jpeg")
        fileRef.getData(maxSize: 1024*1024) { (data, error) in
            guard error == nil else {completion(image); return}
            image = UIImage(data: data!)!
            completion(image)
        }
    
    }
 */
    
}
