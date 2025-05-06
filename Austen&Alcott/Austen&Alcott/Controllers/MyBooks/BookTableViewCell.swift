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
    @IBOutlet weak var imageBook: UIImageView!
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        if let imageUrlString = book.imageUrl, let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error al descargar la imagen: \(error)")
                    DispatchQueue.main.async {
                        self.imageBook.image = UIImage(named: "errorPlaceholder")
                    }
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageBook.image = image
                    }
                }
            }.resume()
        } else {
            self.imageBook.image = UIImage(named: "noImageAvailable")
        }
        
    }
}
