//
//  ViewController.swift
//  Basket
//
//  Created by 1111 on 9.04.21.
//

import UIKit

class BasketViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var getOderButton: UIButton!
    @IBOutlet weak var clearOderButton: UIButton!
    @IBOutlet weak var goToMenuViewButton: UIButton!
    
    @IBOutlet weak var heightOfPriceSection: NSLayoutConstraint!
    
    var orderPrice = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearOderButton.addTarget(self, action: #selector (clearOderButtonAction), for: .touchUpInside)
        getOderButton.addTarget(self, action: #selector (getOderButtonAction), for: .touchUpInside)
        tableView.backgroundColor = UIColor.blue.withAlphaComponent(0.025)
        
        getOderButton.layer.cornerRadius = 5
        
        tableView.dataSource = self
        tableView.delegate = self

        changeOrderPrice()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        changeOrderPrice()
    }
    
    @objc func clearOderButtonAction(){
        //showAllert()
        AlertView.instance.showAlert(title: "Внимание!", message: "Вы уверены что хотите очистить корзину?", alertType: .failure)
        AlertView.instance.callBackAlert = {() in
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.productsInBasket.removeAll()
            productsInBasket.removeAll()
            self.tableView.reloadData()
            self.changeOrderPrice()
        }
    }
    
    @objc func getOderButtonAction(){
        //showAllert()
        AlertView.instance.showAlert(title: "Отправка заказа", message: "Цена может изменяться с учетом действующих акций при подтверждении заказа оператором контакт-центра.", alertType: .success)
        AlertView.instance.callBackAlert = {() in
// MARK: открать новое окно с подтверждением отправки данных
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.productsInBasket.removeAll()
            productsInBasket.removeAll()
            self.tableView.reloadData()
            self.changeOrderPrice()
        }
    }
    
    func changeOrderPrice(){
        orderPrice = 0
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let productsInBasket = appDelegate.productsInBasket
        for productInBasket in productsInBasket{
            orderPrice = orderPrice + productInBasket.product.price * Double(productInBasket.productCount)
        }
        orderPriceLabel.text = "Сумма заказа: \((orderPrice*100).rounded()/100) руб."
    }
    @IBAction func goToMenuView(_ sender: Any) {
        //MARK: переход на выбор продуктов
        print("переход на выбор продуктов")
        tabBarController?.selectedIndex = 0
//        let tabBarController = storyboard?.instantiateViewController(identifier: "TabBarController") as! UITabBarController
//        tabBarController.selectedIndex = 0
////        tabBarController.viewControllers[0]
//        print(tabBarController.viewControllers?.count)
//        tabBarController.selectedViewController = tabBarController.viewControllers![0]
//        tabBarController.transit
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource{
    

    
    
    // MARK: - Table view data source

    
    func numberOfSections(in tableView: UITableView) -> Int {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let productsInBasket = appDelegate.productsInBasket
        if productsInBasket.isEmpty {
            heightOfPriceSection.constant = 0
            priceView.isHidden = true
            goToMenuViewButton.isHidden = false
            return 1
        } else {
            heightOfPriceSection.constant = 120
            priceView.isHidden = false
            goToMenuViewButton.isHidden = true
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let productsInBasket = appDelegate.productsInBasket
        return productsInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let productsInBasket = appDelegate.productsInBasket
        
        let nib = UINib(nibName: "BasketTableViewCell", bundle: .main)
        let cell = nib.instantiate(withOwner: self, options: nil).first as! BasketTableViewCell

       // cell.contentView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cell.fillingCell(productInBasket: productsInBasket[indexPath.row])
        cell.callbackProductInCell = {(productInCell : ProductInBasket) in
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.productsInBasket[indexPath.row] = productInCell
            productsInBasket[indexPath.row] = productInCell
            self.changeOrderPrice()
        }
        cell.deleteCallBack = { () in
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.productsInBasket.remove(at: indexPath.row)
            productsInBasket.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.changeOrderPrice()
        }
        return cell
    }
    
    
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = UINib(nibName: "Header", bundle: .main)
        let headerView = nib.instantiate(withOwner: self, options: nil).first as! Header
        headerView.headerLabel.text = "Текущий Заказ"
        return headerView
    }
    


}


