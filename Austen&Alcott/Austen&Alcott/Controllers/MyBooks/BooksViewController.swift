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
    @IBOutlet weak var header: UIView!
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


    @IBOutlet weak var didTapAvailable: UIButton!
    @IBOutlet weak var didTapHolds: UIButton!
    @IBOutlet weak var didTapLabels: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        obtenerYMostrarLibros() // Llamada a la función para obtener los libros de Firestore

        booksTableView.delegate = self
        booksTableView.dataSource = self

        let buttons = [didTapAvailable, didTapHolds, didTapLabels]
        buttons.forEach { button in
            button?.layer.cornerRadius = 12
            button?.clipsToBounds = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let path = UIBezierPath(
            roundedRect: header.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSizeMake(56, 56)
        )

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        header.layer.mask = mask
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firestoreBooks.count // Usamos el array de Firestore
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell

        let book = firestoreBooks[indexPath.row] // Usamos el array de Firestore
        cell.configure(with: book) // Asegúrate de que tu celda pueda manejar la nueva estructura de Book

        return cell
    }
}
