//
//  UserViewController.swift
//  Austen&Alcott
//
//  Created by Naomi Yumbato 20/04/25.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = UIBezierPath(
            roundedRect: borderView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSizeMake(56, 56)
        )
        
        let mask =  CAShapeLayer()
        mask.path = path.cgPath
        borderView.layer.mask = mask
        
    }

}
