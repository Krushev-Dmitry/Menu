//
//  MenuTableViewController.swift
//  Menu
//
//  Created by 1111 on 22.03.21.
//

import UIKit

var productsInBasket = [ProductInBasket()]

class MenuTableViewController: UITableViewController {

    var products = [Product]()
    var productsName = [String]()
    var productInCells = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsInBasket.removeAll()
//        MARK: parsing from firebase
//        APIManager.shared.readProduct(collection: "Products") { (products) in
//            self.products = products
//
//            self.productInCells.removeAll()
//            var productsName = [String]()
//            for name in products.map({"\($0.name)"}) {
//              if !productsName.contains(name) {
//                productsName.append(name)
//                self.productInCells.append(Product())
//              }
//            }
//
//
//            self.productsName = productsName
//
//            self.tableView.reloadData()
//        }
        startProduct()
        for name in products.map({"\($0.name)"}) {
          if !productsName.contains(name) {
            productsName.append(name)
            productInCells.append(Product())
          }
        }
        self.tableView.reloadData()

    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = UINib(nibName: "MenuSegment", bundle: .main)
        let headerView = nib.instantiate(withOwner: self, options: nil).first as! MenuSegment
        
        
        // добавить скролинг сегментов
        guard let sc = headerView.segmentController else {return headerView}
            sc.removeAllSegments()
            // вставить кол-во секций из БД
            for segment in 0...5{
            sc.insertSegment(withTitle: "номер сегмента \(segment)", at: segment, animated: false)
        }
        
                
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerView.autoresizesSubviews = true
        return headerView

    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return productsName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "MenuTableViewCell2", bundle: .main)
        let cell = nib.instantiate(withOwner: self, options: nil).first as! MenuTableViewCell2


        for productInCell in products {
             if productInCell.name == productsName[indexPath.row]  {
                productInCells[indexPath.row] = productInCell
                cell.productsInCell.append(productInCell)
                cell.fillingCell(product: productInCell)
            }
        }


        cell.showPopUpVC = {(VC: UIViewController) in
            self.present(VC, animated: true, completion: nil)
        }

        cell.callbackProduct = {(product : Product) in
            self.productInCells[indexPath.row] = product
        }
        
        return cell
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("выбрана ячека \(indexPath.row)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ProductVC = storyboard.instantiateViewController(identifier: "ProductVC") as! ProductViewController


        ProductVC.productsInCell = products
        ProductVC.productInCell = productInCells[indexPath.row]
        ProductVC.index = indexPath.row
        ProductVC.callbackProduct = {(product : Product) in
            self.productInCells[indexPath.row] = product
            tableView.reloadData()
        }
        ProductVC.modalPresentationStyle = .popover
        ProductVC.modalTransitionStyle = .crossDissolve

        present(ProductVC, animated: true, completion: nil)
    }

}
