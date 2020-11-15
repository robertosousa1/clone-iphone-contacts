//
//  TemperaturaViewController.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 19/04/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import UIKit

class TemperaturaViewController: UIViewController {
    
    // MARK: Propriedades
    var contato:Contato?
    
    // Capítulo 18
    let APPID = ''
    let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?APPID=" + APPID + "&units=metric"
    let URL_BASE_IMAGE = "http://openweathermap.org/img/w/"

    // MARK: Outlets
    @IBOutlet weak var labelCondicaoAtual: UILabel!
    @IBOutlet weak var labelTemperaturaMaxima: UILabel!
    @IBOutlet weak var labelTemperaturaMinima: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Outlets para modo Size Classes
    @IBOutlet weak var labelNomeContato: UILabel!
    @IBOutlet weak var labelEnderecoContato: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cria notificação para detectar mudança de orientação em tempo real
        NotificationCenter.default.addObserver(self, selector: #selector(TemperaturaViewController.orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view.
        
        // Capítulo 18
        //  Alterações em relação à Apostila
        //      1. Troca de AnyObject, para Any, tipo nativo da Swift
        //      2. Tratamento do campo weather do JSON
        if let contato = self.contato {
            if let endpoint = URL(string: URL_BASE + "&lat=\(contato.latitude ?? 0)&lon=\(contato.longitude ?? 0)") {
                
                let session = URLSession(configuration: .default)
                print(endpoint)
                let task = session.dataTask(with: endpoint) { (data, response, error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        
                        if httpResponse.statusCode == 200 {
                            
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String: AnyObject] {
                                    
                                    /* ORIGINAL APOSTILA */
                                    //  Tem que usar AnyObject
//                                    let main = json["main"] as! [String:AnyObject]
//                                    let weather = json["weather"]![0] as! [String:AnyObject]
//                                    let temp_min = main["temp_min"] as! Double
//                                    let temp_max = main["temp_max"] as! Double
//                                    let icon = weather["icon"] as! String
//                                    let condicao = weather["main"] as! String
                                    /* FIM ORIGINAL APOSTILA */
                                    
                                    /* Sintaxe Alternativa - com Any */
                                    let main = json["main"] as! [String:Any]
                                    // Necessário pois weather é um Array de Dicionário
                                    let weather = json["weather"] as! [Any]?
                                    let fields = weather?[0] as! [String:Any]?
                                    let temp_min = main["temp_min"] as! Double
                                    let temp_max = main["temp_max"] as! Double
                                    let icon = fields?["icon"] as! String
                                    let condicao = fields?["main"] as! String
                                    /* Fim Sintaxe Alternativa */
                                    
                                    DispatchQueue.main.async {
                                        
                                        print(condicao)
                                        print(temp_min)
                                        print(temp_max)
                                        print(icon)
                                        
                                        self.labelCondicaoAtual.text = condicao
                                        self.labelTemperaturaMinima.text = temp_min.description + "º"
                                        self.labelTemperaturaMaxima.text = temp_max.description + "º"
                                        self.pegaImagem(icon)
                                        
                                        self.labelCondicaoAtual.isHidden = false
                                        self.labelTemperaturaMinima.isHidden = false
                                        self.labelTemperaturaMaxima.isHidden = false
                                        
                                        
                                    }
                                }
                            } catch let erro as NSError {
                                print(erro.localizedDescription)
                            }
                        }
                    }
                }
                task.resume()

            }
            
        }

    }
    
    @objc func orientationChanged() {
        // Verifica ambiente (size classes)
        // Carrega campos de contato apenas se estivermos num ambiente wR (Plus e iPads em landscape)
        if sizeClass() == (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact) {
            labelNomeContato.text = contato?.nome
            labelEnderecoContato.text = contato?.endereco
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func pegaImagem(_ icon:String){
        
        if let endpoint = URL(string: URL_BASE_IMAGE + icon + ".png") {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: endpoint) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            print("Exibindo Imagem")
                            self.imageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
            
            task.resume()
        }
        
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Extensão para criar acessar ambiente de size class
extension UIViewController {
    func sizeClass() -> (UIUserInterfaceSizeClass, UIUserInterfaceSizeClass) {
        return(traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass)
    }
}
