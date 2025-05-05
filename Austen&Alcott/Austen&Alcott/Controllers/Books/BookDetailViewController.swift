//
//  BookDetailViewController.swift
//  Austen&Alcott
//
//  Created by Crhistian Ninalaya on 4/05/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookView: UIImageView!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var editorialLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reservationButton: UIButton!
    
    var book: Book?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetailsBook()
        configureReservationButtonStateOnLoad()
    }
    
    func showDetailsBook() {
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
    
    //Si el libro seleccionado esta reservado entonces el boton sera inhabilitado
    func configureReservationButtonStateOnLoad() {
        if let detailedBook = book, detailedBook.isReservate == true {
            reservationButton.isEnabled = false
            reservationButton.setTitle("Reservado", for: .normal)
            reservationButton.backgroundColor = .gray
        } else {
            reservationButton.isEnabled = true
            reservationButton.setTitle("Reservar", for: .normal)
            reservationButton.backgroundColor = view.tintColor // Restaura el color original del botón
        }
    }
    
    @IBAction func didTapReservationBook(_ sender: UIButton) {
        guard let bookToReserve = book, let bookId = bookToReserve.id, let userId = Auth.auth().currentUser?.uid else {
            print("Error: No se pudo obtener la información del libro o del usuario.")
            showAlert(title: "Error", message: "No se pudo realizar la reserva. Inténtalo de nuevo.")
            return
        }

        let reservation = ReserveBook(userId: userId, bookId: bookId, reservationDate: Date())

        // Guardar la reserva en Firestore
        db.collection("ReserveBooks").addDocument(data: reservation.toFirestore()) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error al guardar la reserva en Firestore: \(error)")
                strongSelf.showAlert(title: "Error", message: "Hubo un problema al realizar la reserva. Inténtalo más tarde.")
            } else {
                print("Reserva guardada con éxito en Firestore.")
                strongSelf.showAlert(title: "¡Reserva Exitosa!", message: "El libro '\(bookToReserve.title ?? "Sin título")' ha sido reservado.") {
                    // Actualizar el documento del libro en la colección "books"
                    strongSelf.db.collection("books").document(bookId).updateData(["isReservate": true]) { error in
                        if let error = error {
                            print("Error al actualizar el estado del libro en Firestore: \(error)")
                            // Podrías mostrar un mensaje al usuario indicando que la reserva se realizó,
                            // pero hubo un problema al actualizar la información del libro.
                        } else {
                            print("Estado del libro actualizado a 'reservado' en Firestore.")
                            // Opcional: Actualizar la propiedad local del libro para reflejar el cambio
                            strongSelf.book?.isReservate = true
                            strongSelf.configureReservationButtonStateOnLoad() // Reconfigurar el botón
                        }
                        strongSelf.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
