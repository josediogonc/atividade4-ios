import UIKit
import Firebase

class ToysTableViewController : UITableViewController {
       
    var toys : [Toy] = []
    
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var listener: ListenerRegistration!
    
    func loadToys() {
        listener = firestore.collection(FirebaseConfig.COLLECTION).order(by: "toyName").addSnapshotListener(includeMetadataChanges: true, listener: {
            snapshot, error in
            if let error = error {
                print(error)
            } else {
                guard let snapshot = snapshot else { return }
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showItemsFrom(snapshot)
                }
            }
        })
    
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot) {
        toys.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            print(document.data())
            if let address = data["address"] as? String,
               let conservation = data["conservation"] as? String,
               let donatorName = data["donatorName"] as? String,
               let toyName = data["toyName"] as? String,
               let phone = data["phone"] as? String {
                
                let toy = Toy(toyName: toyName,
                              donatorName: donatorName,
                              address: address,
                              phone: phone,
                              conservation: ConservationState(rawValue: conservation)!,
                              id: document.documentID)
                toys.append(toy)
            }
        }
        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadToys()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let formViewController = segue.destination as? FormViewController,
           let index = tableView.indexPathForSelectedRow {
            formViewController.toy = toys[index.row]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let toy = toys[indexPath.row]
        cell.textLabel?.text = toy.toyName
        cell.detailTextLabel?.text = toy.conservation.rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toy = toys[indexPath.row]
            firestore.collection(FirebaseConfig.COLLECTION).document(toy.id).delete()
        }
    }


}
