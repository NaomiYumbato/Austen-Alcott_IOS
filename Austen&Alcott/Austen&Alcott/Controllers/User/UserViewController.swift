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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = UIBezierPath(
            roundedRect: borderView.bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSizeMake(56, 56)
        )
        
        let mask =  CAShapeLayer()
        mask.path = path.cgPath
        borderView.layer.mask = mask

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    func loadUserData() {
        UserService.shared.getCurrentUser { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.nameLabel.text = "\(user.firstName) \(user.lastName)"
                    self.emailLabel.text = user.email
                }
            case .failure(let error):
                print("Error al obtener usuario: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func didTapCloseSession(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("Usuario desconectado.")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.present(homeVC, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("Error al cerrar sesión: \(signOutError.localizedDescription)")
        }
    }
    
}
