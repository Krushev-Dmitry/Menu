//
//  MenuSegmentController.swift
//  Menu
//
//  Created by 1111 on 22.03.21.
//

import UIKit

class MenuSegment: UIView {
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    



    @IBAction func segmenControllerAction(_ sender: Any) {
        
        print ("\(segmentController.selectedSegmentIndex)")
    }
}
