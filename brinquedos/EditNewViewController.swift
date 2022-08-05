//
//  ViewController.swift
//  issues
//
//  Created by user225450 on 7/27/22.
//

import UIKit

class EditNewViewController: UIViewController {

    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var localizacao: UITextField!
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var selecionar: UIButton!
    
    var issue : Issue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let issue = issue {
            title = "Alterar"
            titulo.text = issue.title
            descricao.text = issue.summary
            localizacao.text = issue.location
            mainButton.setTitle("Salvar", for: .normal)
            if let img = issue.image {
                imagem.image = UIImage(data: img)
            }        }
    }

    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Seleciona a imagem", message: "De onde você deseja selecionar a imagem?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Galeria", style: .default) { _ in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let albumAction = UIAlertAction(title: "Álbum de fotos", style: .default) { _ in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePiker = UIImagePickerController()
        imagePiker.sourceType = sourceType
        imagePiker.delegate = self
        present(imagePiker, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if issue == nil {
            issue = Issue(context: context)
        }
        issue?.title = titulo.text
        issue?.summary = descricao.text
        issue?.location = localizacao.text
        issue?.date = Date()
        issue?.image = imagem.image?.jpegData(compressionQuality: 0.7)
        
        try? context.save()
        
        navigationController?.popViewController(animated: true)
    }
}

extension EditNewViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagem.image = image
        }
        
        dismiss(animated: true)
    }
}

