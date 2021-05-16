//
//  AlertView.swift
//  CustomAlert
//
//  Created by SHUBHAM AGARWAL on 31/12/18.
//  Copyright © 2018 SHUBHAM AGARWAL. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView, UIGestureRecognizerDelegate {
    // add this text where you need to call alert
//            AlertView.instance.showAlert(title: "Failure", message: "You are not loged into the system.", alertType: .failure)
    
    
    static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    

    let panGestureRecognizer = UIPanGestureRecognizer()
    var panGestureAnchorPoint: CGPoint?
    var callBackAlert : (() -> ())?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        img.layer.cornerRadius = 30
        
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        
        alertView.layer.cornerRadius = 10
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        parentView.backgroundColor = .none
    }
    
    enum AlertType {
        case success
        case failure
        case attention
    }
    
    
    
    func showAlert(title: String, message: String, alertType: AlertType) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        parentView.addGestureRecognizer(tap)
        parentView.isUserInteractionEnabled = true
       
        self.titleLbl.text = title
        self.messageLbl.text = message
        
        switch alertType {
        case .success:
            img.image = UIImage(named: "Success")
            doneBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .failure:
            img.image = UIImage(named: "Failure")
            doneBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .attention:
            img.image = UIImage(named: "Attention")
            doneBtn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        }
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tap = sender.location(in: parentView)
        // если нажимаем мимо окна, закрываем alert
        if !alertView.convert(img.frame, to: parentView).contains(tap) &&
            !alertView.frame.contains(tap){
            parentView.removeFromSuperview()
            }
    }

    
    @IBAction func onClickDone(_ sender: Any) {
        parentView.removeFromSuperview()
        if callBackAlert != nil{
        callBackAlert!()
        }
    }
}
