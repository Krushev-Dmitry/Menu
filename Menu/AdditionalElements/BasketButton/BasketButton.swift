//
//  Basket.swift
//  BasketButton
//
//  Created by 1111 on 10.04.21.
//

import Foundation
import UIKit


class BasketButton : UIView {
    var count : Int = 0
    var callbackCount : ((Int) -> ())?

    @objc private let minus : UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("-", for: .normal)
        button.titleLabel?.font =  UIFont(name: (button.titleLabel?.font.familyName)!,
                                          size: 20)
        button.setTitleColor(.init(white: 0.5, alpha: 1), for: .highlighted)
        button.addTarget(self, action: #selector (minusAction), for: .touchUpInside)
        return button
    }()


    private let countLabel : UILabel = {
        let  label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    @objc private let plus : UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("+", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font =  UIFont(name: (button.titleLabel?.font.familyName)!,
                                          size: 20)
        button.setTitleColor(.init(white: 0.5, alpha: 1), for: .highlighted)
        button.addTarget(self, action: #selector (plusAction), for: .touchUpInside)
   
        return button
    }()
    
    func configure(count: Int) {
        self.count = count
        self.countLabel.text = String(count)
        layoutSubviews()
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 5
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.5
        
        addSubview(self.minus)
        addSubview(self.countLabel)
        addSubview(self.plus)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if count > 0 {
            plus.setTitle("+", for: .normal)
            plus.setImage(nil, for: .normal)
            minus.isHidden = false
            countLabel.isHidden = false
        minus.frame = CGRect(
                            x: 0, y: 0,
                            width: frame.width/3,
                            height: frame.height)
        countLabel.frame = CGRect(
                            x: frame.width/3, y: 0,
                            width: frame.width/3,
                            height: frame.height)
        plus.frame = CGRect(
                            x: 2*frame.width/3, y: 0,
                            width: frame.width/3,
                            height: frame.height)
        }
        else {
            minus.isHidden = true
            countLabel.isHidden = true
            plus.frame = CGRect(
                                x: 0, y: 0,
                                width: frame.width,
                                height: frame.height)
            plus.setTitle("", for: .normal)
            let image = UIImage(systemName: "cart")
            plus.setImage(image, for: .normal)
        }
    }
    
    
    @objc func plusAction(sender: UIButton){
        print("plus is Pressed")
        count = count + 1
        configure(count: count)
    }
    @objc func minusAction(sender: UIButton){
        print("minus is Pressed")
        count = count - 1
        configure(count: count)
    }
    
    
}
