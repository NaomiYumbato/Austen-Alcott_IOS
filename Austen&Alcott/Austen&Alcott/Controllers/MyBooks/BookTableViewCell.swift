//
//  BookTableViewCell.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 17/04/25.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageBook: UIImageView!

    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author

        if let imageUrlString = book.imageUrl, let imageUrl = URL(string: imageUrlString) {
            // Iniciar una tarea asíncrona para descargar la imagen
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error al descargar la imagen: \(error)")
                    DispatchQueue.main.async {
                        self.imageBook.image = UIImage(named: "errorPlaceholder")
                    }
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    // Asegurarse de que la actualización de la UI se realice en el hilo principal
                    DispatchQueue.main.async {
                        self.imageBook.image = image
                    }
                }
            }.resume() // ¡No olvides llamar a resume() para iniciar la tarea!
        } else {
            self.imageBook.image = UIImage(named: "noImageAvailable")
        }

        // progressLabel.text = "\(book.progress)%"
        // progressView.progress = Float(book.progress) / 100.0
    }

    // ... (resto de la clase)
}
