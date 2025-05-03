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
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        progressLabel.text = "\(book.progress)%"
        progressView.progress = Float(book.progress) / 100.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
