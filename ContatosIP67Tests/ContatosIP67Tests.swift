//
//  ContatosIP67Tests.swift
//  ContatosIP67Tests
//
//  Created by Carlos A Savi on 12/07/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import XCTest
@testable import ContatosIP67

class ContatosIP67Tests: XCTestCase {
    

    // Alternative way to present the new view controller
//    self.navigationController?.showViewController(vc, sender: nil)
//    
//    var formulario = FormularioContatoViewController(coder: aDecoder)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWhenWeCallpegaDadosDoFormulario() {
        
        // Na criação de um novo contato
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Form-Contato") as!
        FormularioContatoViewController

        vc.contato = nil
        vc.viewDidLoad()
        vc.pegaDadosDoFormulario()
        
        XCTAssertNotNil(vc.contato, "não foi possível criar um Contato")
    }
    
}
