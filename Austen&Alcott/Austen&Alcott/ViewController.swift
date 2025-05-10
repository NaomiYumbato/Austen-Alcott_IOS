//
//  ViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 15/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController{
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var horizontallyScrollableStackView: UIStackView!
    @IBOutlet weak var bordeView: UIView!
    
    @IBOutlet weak var borderBottom: UIView!
    let bookService = BookService()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let path = UIBezierPath(
            roundedRect: bordeView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSizeMake(56, 56)
        )
        let pathbottom = UIBezierPath(
            roundedRect: borderBottom.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSizeMake(56, 56)
        )
        let mask =  CAShapeLayer()
        let maskbottom =  CAShapeLayer()
        
        mask.path = path.cgPath
        maskbottom.path = pathbottom.cgPath
        
        bordeView.layer.mask = mask
        borderBottom.layer.mask = maskbottom
        
        loadUserData()
        loadBooksFromFirestore()
    }
        
        func loadUserData() {
            UserService.shared.getCurrentUser { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.userNameLabel.text = "Bienvenido(a), \(user.firstName)"
                    }
                case .failure(let error):
                    print("Error al obtener usuario: \(error.localizedDescription)")
                }
            }
        }

        func loadBooksFromFirestore() {
            bookService.getAllBooks { books in
                DispatchQueue.main.async {
                    for book in books {
                        guard
                            let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)?.first as? DayView,
                            let urlString = book.imageUrl,
                            let url = URL(string: urlString)
                        else { continue }

                        dayView.book = book
                        dayView.translatesAutoresizingMaskIntoConstraints = false
                        dayView.widthAnchor.constraint(equalToConstant: self.horizontallyScrollableStackView.frame.height).isActive = true
                        self.horizontallyScrollableStackView.addArrangedSubview(dayView)

                        // Acción al tocar la imagen
                        dayView.onTap = { [weak self] selectedBook in
                            guard let self = self else { return }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let detailVC = storyboard.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController {
                                detailVC.book = selectedBook
                                self.navigationController?.pushViewController(detailVC, animated: true)
                            }
                        }

                        // Cargar imagen
                        URLSession.shared.dataTask(with: url) { data, _, _ in
                            guard let data = data else { return }
                            DispatchQueue.main.async {
                                dayView.bookImageView.image = UIImage(data: data)
                            }
                        }.resume()
                    }
                }
            }
        }

}


