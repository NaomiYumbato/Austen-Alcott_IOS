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
    
    // Este closure lo va a definir el ViewController
    var onTap: ((Book) -> Void)?

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
        guard let book = book else { return }
        onTap?(book)
    }
}
