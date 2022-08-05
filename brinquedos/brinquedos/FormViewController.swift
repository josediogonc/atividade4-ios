import UIKit
import Firebase

class FormViewController : UIViewController {

    @IBOutlet weak var nomeBrinquedo: UITextField!
    @IBOutlet weak var nomeDoador: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var conservacao: UISegmentedControl!
    @IBOutlet weak var telefone: UITextField!
    
    @IBOutlet weak var mainButton: UIButton!
    
    var toy : Toy?
    
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toy = toy {
            title = "Alterar"
            nomeBrinquedo.text = toy.toyName
            nomeDoador.text = toy.donatorName
            endereco.text = toy.address
            telefone.text = toy.phone
            conservacao.selectedSegmentIndex = toy.conservation.getSegmentIndex()
            mainButton.setTitle("Salvar", for: .normal)
        }

    }
    
    @IBAction func save(_ sender: UIButton){
        var conservation : ConservationState
        switch conservacao.selectedSegmentIndex {
            case 0: conservation = ConservationState.NOVO
            case 1: conservation = ConservationState.USADO
            case 2: conservation = ConservationState.REPARO
            default: return
        }
        let data: [String : String] = [
            "toyName" : nomeBrinquedo.text ?? "Brinquedo sem nome",
            "donatorName" : nomeDoador.text ?? "Doador desconhecido",
            "address" : endereco.text ?? "Endereço não informado",
            "phone" : telefone.text ?? "Telefone não informado",
            "conservation" : conservation.rawValue
        ]
        let db = self.firestore.collection(FirebaseConfig.COLLECTION)
        
        if let t = toy {
            db.document(t.id).updateData(data)
        } else {
            db.addDocument(data: data)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
