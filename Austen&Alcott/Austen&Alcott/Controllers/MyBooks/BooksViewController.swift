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
    let db = Firestore.firestore()

    var firestoreBooks: [Book] = [] // Array para almacenar los libros de Firestore

    func obtenerYMostrarLibros() {
        db.collection("books").getDocuments { [weak self] (querySnapshot, error) in
            guard let strongSelf = self else { return }

            if let error = error {
                print("Error al obtener documentos: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No se encontraron documentos en la colección 'books'.")
                return
            }

            strongSelf.firestoreBooks = [] // Limpiamos el array antes de agregar nuevos datos

            for document in documents {
                let data = document.data()
                let book = Book(
                    author: data["author"] as? String,
                    description: data["description"] as? String,
                    editorial: data["editorial"] as? String,
                    imageUrl: data["imageUrl"] as? String,
                    isReservate: data["isReservate"] as? Bool,
                    title: data["title"] as? String
                )
                strongSelf.firestoreBooks.append(book)
            }

            DispatchQueue.main.async {
                strongSelf.booksTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        obtenerYMostrarLibros()

        booksTableView.delegate = self
        booksTableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firestoreBooks.count // Usamos el array de Firestore
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell

        let book = firestoreBooks[indexPath.row] // Usamos el array de Firestore
        cell.configure(with: book)

        return cell
    }
    

    // MARK: - Navigation
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
