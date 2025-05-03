//
//  ViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 15/04/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //Funcionalidad a remover cuando implementemos todo el flujo de la app
    @IBAction func didTapGoBooks(_ sender: UIButton) {
        print("Button presionado")
        let storyboard = UIStoryboard(name: "MyBooks", bundle: nil)
        
        if let booksVC = storyboard.instantiateViewController(withIdentifier: "BooksViewController") as? BooksViewController {
            self.navigationController?.pushViewController(booksVC, animated: true)
        } else {
            print("No se pudo cargar el BooksViewcontroller")
        }
    }
}

