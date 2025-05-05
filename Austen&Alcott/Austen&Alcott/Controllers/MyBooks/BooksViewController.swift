//
//  BooksViewController.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 17/04/25.
//

import UIKit
import FirebaseFirestore

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var booksTableView: UITableView!
    let bookService = BookService()
    // Array para almacenar los libros de Firestore
    var firestoreBooks: [Book] = []
    
    /// Obtenemos todos los libros desde Firestore usando BookService y actualizamos la table view
    func fetchAndDisplayBooks() {
        bookService.getAllBooks { [weak self] books in
            guard let strongSelf = self else {
                return
            }
            strongSelf.firestoreBooks = books
            DispatchQueue.main.async {
                strongSelf.booksTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAndDisplayBooks()
        booksTableView.delegate = self
        booksTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firestoreBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        
        let book = firestoreBooks[indexPath.row]
        cell.configure(with: book)
        
        return cell
    }
    
    // MARK: - Navigation
    ///Obtenemos el segue que se dispara al selecionar una celda para enviar el libro seleccionado al controlador que se encarga de los detalles
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookDetail" {
            if let detailVC = segue.destination as? BookDetailViewController,
               let selectedCell = sender as? BookTableViewCell,
               let indexPath = booksTableView.indexPath(for: selectedCell) {
                let selectedBook = firestoreBooks[indexPath.row]
                detailVC.book = selectedBook
            }
        }
    }
}
