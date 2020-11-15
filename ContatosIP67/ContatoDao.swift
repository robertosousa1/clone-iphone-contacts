//
//  ContatoDao.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 25/03/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ContatoDao: CoreDataUtil {

    static private var defaultDao: ContatoDao!
    var contatos: Array<Contato>!
    
    static func sharedInstance() -> ContatoDao {
        if defaultDao == nil {
            defaultDao = ContatoDao()
        }
        return defaultDao
    }
    
    override private init() {
        
        // Apostila pede pra tirar essa inicialização
        // contatos = Array()
        
        super.init()
        
        // Capítulo 17
        inserirDadosIniciais()
        
        print("Caminho do BD: \(NSHomeDirectory())")
        
        carregaContatos()
    }
    
    // Capítulo 17
    private func inserirDadosIniciais() {
        
        let configuracoes = UserDefaults.standard
        let dadosInseridos = configuracoes.bool(forKey: "dados_inseridos")
        
        if !dadosInseridos {
            
            print("Carga inicial")
            
            let caelum = NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
                                                             
            caelum.nome = "Caelum SP"
            caelum.endereco = "Rua vergueiro, 3185, São Paulo - SP"
            caelum.telefone = "01155712751"
            caelum.site = "http://www.caelum.com.br"
            caelum.latitude = -23.5883034
            caelum.longitude = -46.632369
            
            self.saveContext()
            
            configuracoes.set(true, forKey: "dados_inseridos")
            
            configuracoes.synchronize()
        }
    }
    
    // capítulo 17
    private func carregaContatos() {
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        busca.sortDescriptors = [orderPorNome]
        
        
        do {
            self.contatos = try self.persistentContainer.viewContext.fetch(busca)
        }catch let error as NSError {
            print("Fetch Falhou: \(error.localizedDescription)")
        }
        
    }

    // CAPÍTULO 17
    func novoContato() -> Contato {
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
    }

    func adiciona(_ contato:Contato) {
        contatos.append(contato)
        
        // EXTRA - Item 5 do Exercício 17.14
        saveContext()
    }
    
    func listaTodos() -> [Contato] {
        return contatos
    }
    
    func buscaContatoNaPosicao(_ posicao:Int) -> Contato {
        return contatos[posicao]
    }
    
    func remove(_ posicao:Int) {
        
        // Extra - Item 5 do Exercício 17.14
        persistentContainer.viewContext.delete(contatos[posicao])
        saveContext()
        
        // Primeiro do banco, depois do Array
        contatos.remove(at:posicao)


    }
    
    func buscaPosicaoDoContato(_ contato: Contato) -> Int {
        return contatos.index(of: contato)!
    }
    
}
