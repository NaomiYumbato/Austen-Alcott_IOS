//
//  UserViewController.swift
//  Austen&Alcott
//
//  Created by Naomi Yumbato 20/04/25.
//

import UIKit
import FirebaseAuth

class UserViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
        let path = UIBezierPath(
            roundedRect: borderView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSizeMake(56, 56)
        )
        
        let mask =  CAShapeLayer()
        mask.path = path.cgPath
        borderView.layer.mask = mask
        
    }
    
    func getUser() {
        let _ = Auth.auth().currentUser?.email
    }
    
    @IBAction func didTapCloseSession(_ sender: UIButton) {
        do {
                try Auth.auth().signOut()
                print("Usuario desconectado.")
                    
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    self.present(loginVC, animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
                print("Error al cerrar sesión: \(signOutError.localizedDescription)")
            }
    }
    
}
