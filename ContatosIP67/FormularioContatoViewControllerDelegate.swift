//
//  FormularioContatoViewControllerDelegate.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 10/04/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import Foundation

protocol FormularioContatoViewControllerDelegate {
    func contatoAtualizado(_ contato:Contato)
    func contatoAdicionado(_ contato:Contato)
}
