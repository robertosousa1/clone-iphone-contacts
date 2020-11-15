//
//  ListaContatosViewController.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 25/03/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import UIKit

class ListaContatosViewController: UITableViewController, FormularioContatoViewControllerDelegate {
    
    var dao:ContatoDao
    
    var linhaDestaque: IndexPath?
    
    static let cellIdentifier:String = "Cell"
    
    required init?(coder aDecoder: NSCoder) {
        dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    // Implementação dos Protocolos
    func contatoAtualizado(_ contato: Contato) {
        self.linhaDestaque = IndexPath(row: dao.buscaPosicaoDoContato(contato), section: 0)
        print("Contato atualizado: \(contato.nome)")
        
        // Extra - Item 5 do Exercício 17.14
        ContatoDao.sharedInstance().saveContext()
    }
    
    func contatoAdicionado(_ contato: Contato) {
        self.linhaDestaque = IndexPath(row: dao.buscaPosicaoDoContato(contato), section: 0)
        print("Contato adicionado: \(contato.nome)")
        
        // Extra - Item 5 do Exercício 17.14
        //  Aproveita para salvar o contexto
        ContatoDao.sharedInstance().saveContext()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // ERRATA: Exercício 10.4 - Removendo um contato
        // Esse é o lugar correto para esse comando
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        // Capítulo 13 - Gestos
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exibirMaisAcoes(gesture:)))
        
         self.tableView.addGestureRecognizer(longPress)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
        if let linha = linhaDestaque {
            self.tableView.selectRow(at: linha, animated: true, scrollPosition: .middle)
            linhaDestaque = Optional.none
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.tableView.deselectRow(at: linha, animated: true)
                self.linhaDestaque = .none
            }

        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dao.listaTodos().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let contato:Contato = dao.buscaContatoNaPosicao(indexPath.row)
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ListaContatosViewController.cellIdentifier)
 
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ListaContatosViewController.cellIdentifier)
        }
        
        cell!.textLabel?.text = contato.nome
        
        return cell!
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Exclui o dado
            self.dao.remove(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contatoSelecionado = dao.buscaContatoNaPosicao(indexPath.row)
        
        print("Nome: \(contatoSelecionado.nome)")

        exibeFormulario(contatoSelecionado)
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FormSegue" {
            if let formulario = segue.destination as? FormularioContatoViewController {
                formulario.delegate = self
            }
        }
    }
    
    // Para exibir formuário de contatos, quando o cliente selecionar uma célula de contato
    func exibeFormulario(_ contato:Contato) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let formulario = storyboard.instantiateViewController(withIdentifier: "Form-Contato") as!
        FormularioContatoViewController
        formulario.delegate = self
        formulario.contato = contato
        self.navigationController?.pushViewController(formulario, animated: true)
    }
    
    // Capítulo 13 - Gestos
    @objc func exibirMaisAcoes(gesture: UIGestureRecognizer) {
        
        if gesture.state == .began {
            let ponto = gesture.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at:ponto) {
                let contato = self.dao.buscaContatoNaPosicao(indexPath.row)
                let acoes = GerenciadorDeAcoes(do: contato)
                acoes.exibirAcoes(em: self)
            }
        }
    }
}
