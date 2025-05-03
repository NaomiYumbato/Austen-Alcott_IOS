//
//  NavigationTab.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 28/04/25.
//

import UIKit

class NavigationTab: UITabBar {

    // PAra darle borde y tamaño personalizado a la UITabBar
    override func sizeThatFits(_ size: CGSize) -> CGSize {
         var sizeThatFits = super.sizeThatFits(size)
         sizeThatFits.height = 100
         return sizeThatFits
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = 30.0
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
    }

}
