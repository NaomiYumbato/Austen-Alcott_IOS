//
//  BookDetailViewController.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 4/05/25.
//

import UIKit
import FirebaseFirestore

class BookDetailViewController: UIViewController {

    @IBOutlet weak var bookView: UIImageView!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var editorialLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var book: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDetallesDelLibro()
    }

    func mostrarDetallesDelLibro() {
        guard let detailedBook = book else {
            print("Error: No se recibió información del libro.")
            autorLabel.text = "Error al cargar detalles"
            editorialLabel.text = ""
            descriptionTextView.text = ""
            bookView.image = UIImage(named: "errorPlaceholder")
            return
        }

        autorLabel.text = detailedBook.author ?? "Autor no disponible"
        editorialLabel.text = detailedBook.editorial ?? "Editorial no disponible"
        descriptionTextView.text = detailedBook.description ?? "Descripción no disponible"

        if let imageUrlString = detailedBook.imageUrl, let imageUrl = URL(string: imageUrlString) {
            bookView.image = UIImage(named: "placeholder")
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error al descargar la imagen: \(error)")
                    DispatchQueue.main.async {
                        self.bookView.image = UIImage(named: "noImageAvailable")
                    }
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.bookView.image = image
                    }
                }
            }.resume()
        } else {
            bookView.image = UIImage(named: "noImageAvailable")
        }
    }
}
