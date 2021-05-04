//
//  TableViewCellTest.swift
//  Menu
//
//  Created by 1111 on 3.05.21.
//

import UIKit

class TableViewCellTest: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var attention: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var weight: UILabel!
    
    
    @IBOutlet weak var attentionTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionTop: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
