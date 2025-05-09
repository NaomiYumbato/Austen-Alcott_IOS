//
//  ViewController.swift
//  Austen&Alcott
//
//  Created by DAMII on 15/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        // 1. Crear el UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Establecer el desplazamiento horizontal
        layout.itemSize = CGSize(width: 150, height: 250) // Tamaño de cada celda
        layout.minimumInteritemSpacing = 10 // Espacio mínimo entre celdas horizontalmente
        layout.minimumLineSpacing = 10 // Espacio mínimo entre filas (aunque aquí no aplica directamente)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Márgenes alrededor de la sección

        // 2. Inicializar el UICollectionView
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self

        // 3. Registrar la celda
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CeldaHorizontal")
    }
    
    
    func getUser() {
        guard let email = Auth.auth().currentUser?.email else {
            print("No hay usuario autenticado.")
            return
        }

        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        // Buscamos el documento del usuario por su email
        usersRef.whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error al obtener el usuario: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No se encontró ningún usuario con ese correo")
                return
            }
            
            let document = documents.first!
            let userData = document.data()
            
            // Actualizamos el nombre del usuario en la interfaz
            if let name = userData["firstName"] as? String {
                DispatchQueue.main.async {
                    self.userNameLabel.text = "Bienvenido(a), \(name)"
                }
            }
        }
    }
    
    let datos = ["Dato 1", "Dato 2", "Dato 3", "Dato 4", "Dato 5", "Dato 6", "Dato 7", "Dato 8", "Dato 9", "Dato 10"]

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CeldaHorizontal", for: indexPath)
        cell.backgroundColor = .systemBlue
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = datos[indexPath.item]
        label.textAlignment = .center
        label.textColor = .white
        cell.contentView.addSubview(label)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout (Opcional para ajustar el tamaño dinámicamente)

    // Si quieres un tamaño de celda dinámico basado en el contenido, puedes implementar estos métodos.
    // Por ahora, el tamaño está fijo en el layout.

    
    // Acción del botón para navegar a la vista de libros
    @IBAction func didTapGoBooks(_ sender: UIButton) {
        print("Button presionado")
        let storyboard = UIStoryboard(name: "MyBooks", bundle: nil)
        
        if let booksVC = storyboard.instantiateViewController(withIdentifier: "BooksViewController") as? BooksViewController {
            self.navigationController?.pushViewController(booksVC, animated: true)
        } else {
            print("No se pudo cargar el BooksViewController")
        }
    }
}
