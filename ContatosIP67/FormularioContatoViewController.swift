//
//  ViewController.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 25/03/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioContatoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dao:ContatoDao
    var contato: Contato!
    var delegate:FormularioContatoViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var nome: UITextField!
    @IBOutlet var telefone: UITextField!
    @IBOutlet var endereco: UITextField!
    @IBOutlet var site: UITextField!
    @IBOutlet var imageView: UIImageView!
    // Capítulo 16
    @IBOutlet var latitude: UITextField!
    @IBOutlet var longitude: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func criaContato(){
        
        pegaDadosDoFormulario()
        
        dao.adiciona(contato)
        
        self.delegate?.contatoAdicionado(contato)
        
        navigationController?.popViewController(animated: true)
    }
    
    // Capítulo 16
    @IBAction func buscaCoordenadas(sender: UIButton) {
        
        // DESAFIO - Apostila página 191
        // Verifica se campo de endereço está preenchido
        if endereco.text == "" {
            let alerta = UIAlertController(title: "Erro de Consistência", message: "Favor preencher o campo de Endereço ", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerta.addAction(action)
            self.present(alerta, animated: true, completion: nil)
        }
        
        loading.startAnimating()
        sender.isEnabled = false
        
        let geocoder:CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(endereco.text!) { (resultado, error) in
            
            if error == nil && (resultado?.count)! > 0 {
                let placemark = resultado![0]
                let coordenada = placemark.location!.coordinate
                self.latitude.text = coordenada.latitude.description
                self.longitude.text = coordenada.longitude.description
            }
            
            self.loading.stopAnimating()
            sender.isEnabled = true
        }
        

    }
    
    func pegaDadosDoFormulario() {
//        let nome = self.nome.text!
//        let telefone = self.telefone.text!
//        let endereco = self.endereco.text!
//        let site  = self.site.text!
//        print("Nome: \(nome), Telefone: \(telefone), Endereço: \(endereco), Site: \(site)")
        
        // Para descobrir se estamos em edição ou criando um novo contato
        if contato == nil {
            // Before CoreData
            //contato = Contato()
            // After CoreData - Capítulo 17
            contato = dao.novoContato()
        }
        
        if let imagem =  imageView.image {
            contato.foto = imagem
        }
        //contato.foto = imageView.image
        contato.nome = nome.text!
        contato.telefone = telefone.text!
        contato.endereco = endereco.text!
        contato.site  = site.text!

        // Capítulo 16
        if let latitude = Double(latitude.text!) {
            contato.latitude = latitude as NSNumber
        }
        if let longitude = Double(longitude.text!) {
            contato.longitude = longitude as NSNumber
        }
        
        print(contato)
    }
    
    @objc func atualizaContato() {
        pegaDadosDoFormulario()
        
        self.delegate?.contatoAtualizado(contato)
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if contato != nil {
            nome.text = contato.nome
            telefone.text = contato.telefone
            endereco.text = contato.endereco
            site.text = contato.site

            // Capítulo 16
            longitude.text = contato.longitude?.description
            latitude.text = contato.latitude?.description
            
            // Capítulo 14
            if let foto = contato.foto {
                imageView.image = foto
            }
            
            // Capítulo 16 - Quando a tela for carregada
            let botaoAlterar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector(atualizaContato))
            
            self.navigationItem.rightBarButtonItem = botaoAlterar
        }
        
        // Capítulo 14
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionarFoto(sender:)))
        
        self.imageView.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // EXERCÍCIO OPCIONAL
    //  Escolher entre Câmera ou Biblioteca
    private func pegarImage(da sourceType: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selecionarFoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //câmera disponível
            let alert = UIAlertController(title: "Escolha foto do contato", message: contato
                .nome, preferredStyle: .actionSheet)
            // Comando acima pode quebrar se contato for nulo
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let tirarFoto = UIAlertAction(title: "Tirar Foto", style: .default) { (action) in
                self.pegarImage(da: .camera)
            }
            
            let escolherFoto = UIAlertAction(title: "Escolher da biblioteca", style: .default) { (action) in
                    self.pegarImage(da: .photoLibrary)
            }
            
            alert.addAction(cancelar)
            alert.addAction(tirarFoto)
            alert.addAction(escolherFoto)
            self.present(alert, animated: true, completion: nil)
            
            // Requer permissão na info.plist
            //  Privacy - Câmera Usage Permission
            
        } else {
            
            //usar biblioteca
            self.pegarImage(da: .photoLibrary)
            
        }
    }

    /* selecionarFoto Original (antes do exercício opcional
    
//    func selecionarFoto(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            
//            //câmera disponível
//            
//            
//            // Requer permissão na info.plist
//            //  Privacy - Câmera Usage Permission
//            
//        } else {
//            
//            //usar biblioteca
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.allowsEditing = true
//            // Requer permissão na info.plist
//            //  Privacy - Photo Library Usage Permission
//            imagePicker.delegate = self
//            self.present(imagePicker, animated: true, completion: nil)
//            
//        }
//    }
    
 Fim selecionarFoto Original */
    
    
    // Delegates do ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let imagemSelecionada = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            self.imageView.image = imagemSelecionada
            
        }
        
        picker.dismiss(animated: true, completion: nil)

    }

    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
