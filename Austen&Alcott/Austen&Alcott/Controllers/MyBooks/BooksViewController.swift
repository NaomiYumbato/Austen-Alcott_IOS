import UIKit
import FirebaseFirestore

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var booksTableView: UITableView!
    let bookService = BookService()
    // Array para almacenar los libros reservados del usuario
    var reservedBooks: [Book] = []
    
    /// Obtenemos los libros reservados por el usuario actual desde Firestore y actualizamos la table view
    func fetchAndDisplayReservedBooks() {
        bookService.getReservedBooksForCurrentUser { [weak self] books in
            guard let strongSelf = self else {
                return
            }
            strongSelf.reservedBooks = books
            DispatchQueue.main.async {
                strongSelf.booksTableView.reloadData()
                if books.isEmpty {
                    strongSelf.showAlert(title: "Sin Reservas", message: "Todavía no has reservado ningún libro.")
                }
            }
        }
    }
    
    //Esto solo actua la primera vez que se renderiza la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksTableView.delegate = self
        booksTableView.dataSource = self
    }
    //En cambio, este metodo se ejecuta cada vez que se vaya a renderizar la vista
    //Por ello moveremos el metodo para traer data aqui
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndDisplayReservedBooks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        
        let book = reservedBooks[indexPath.row]
        cell.configure(with: book)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: - Navigation
    ///Obtenemos el segue que se dispara al seleccionar una celda para enviar el libro seleccionado al controlador que se encarga de los detalles
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookDetail" {
            if let detailVC = segue.destination as? BookDetailViewController,
               let selectedCell = sender as? BookTableViewCell,
               let indexPath = booksTableView.indexPath(for: selectedCell) {
                let selectedBook = reservedBooks[indexPath.row]
                detailVC.book = selectedBook
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
