//
//  DayView.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 9/05/25.
//

import UIKit

class DayView: UIView {
    @IBOutlet weak var bookImageView: UIImageView!
    var book: Book?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        bookImageView.isUserInteractionEnabled = true
        bookImageView.addGestureRecognizer(tap)
    }

    @objc private func imageTapped() {
        if let title = book?.title {
            print("Libro seleccionado: \(title)")
        }
    }
}
