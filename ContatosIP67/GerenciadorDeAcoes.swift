//
//  GerenciadorDeAcoes.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 11/04/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import Foundation
import UIKit

// Capítulo 13 - Gestos
class GerenciadorDeAcoes {
    
    let contato:Contato
    var controller: UIViewController!
    
    init(do contato:Contato) {
        self.contato = contato
    }
    
    func exibirAcoes(em controller: UIViewController) {
    
        self.controller = controller
        
        let alertView = UIAlertController(title: self.contato.nome, message: nil, preferredStyle: .actionSheet)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let ligarParaContato = UIAlertAction(title: "Ligar", style: .default) { action in
            self.ligar()
        }
        
        let exibirContatosNoMapa = UIAlertAction(title: "Visualizar no Mapa", style: .default) { action in
            self.abrirMapa()
        }
        
        let exibirSiteDoContato = UIAlertAction(title: "Visualizar Site", style: .default) { action in
            self.abrirNavegador()
        }
        
        // Capítulo 18
        let exibirTemperatura = UIAlertAction(title: "Visualizar Clima", style: .default){ action in
            self.exibirTemperatura()
        }
        
        alertView.addAction(cancelar)
        alertView.addAction(ligarParaContato)
        alertView.addAction(exibirContatosNoMapa)
        alertView.addAction(exibirSiteDoContato)
        // Capítulo 18
        alertView.addAction(exibirTemperatura)
        
        self.controller.present(alertView, animated: true, completion: nil)
    }
    
    // Exercício 13.4
    private func abrirAplicativo(com url:String) {
        
        UIApplication.shared.open(URL(string: url)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    private func ligar() {
        
        let device = UIDevice.current
        
        if device.model == "iPhone" {
            print("UUID \(device.identifierForVendor!)")
            abrirAplicativo(com: "tel:" + self.contato.telefone!)
        } else {
            let alert = UIAlertController(title: "Impossivel fazer Ligações", message: "Seu dispositivo não é um IPhone", preferredStyle: .alert)
            let acao = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(acao)
            self.controller.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func abrirNavegador() {
        
        var url = contato.site!
        
        if !url.hasPrefix("http://") {
            url = "http://" + url
        }
        
        abrirAplicativo(com: url)
        
    }
    
    private func abrirMapa() {
        
        let url = ("http://maps.google.com/maps?q=" + self.contato.endereco!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        abrirAplicativo(com: url)
        
    }
    
    private func exibirTemperatura() {
        let temperaturaViewController = controller.storyboard?.instantiateViewController(withIdentifier: "temperaturaViewController") as! TemperaturaViewController
        
        temperaturaViewController.contato = self.contato
        
        controller.navigationController?.pushViewController(temperaturaViewController, animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
