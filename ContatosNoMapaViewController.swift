//
//  ContatosNoMapaViewController.swift
//  ContatosIP67
//
//  Created by Carlos A Savi on 11/04/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

import UIKit
import MapKit

class ContatosNoMapaViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    // Capítulo 16
    var contatos: [Contato] = Array()
    let dao:ContatoDao = ContatoDao.sharedInstance()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.requestWhenInUseAuthorization()
        
        let botaoLocalizacao = MKUserTrackingBarButtonItem(mapView: self.mapa)
        
        self.navigationItem.rightBarButtonItem = botaoLocalizacao
        
        mapa.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contatos = dao.listaTodos()
        mapa.addAnnotations(contatos)

    }

    override func viewWillDisappear(_ animated: Bool) {
        mapa.removeAnnotations(contatos)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mapa delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "pino"
        
        var pino:MKPinAnnotationView
        
        if let reusablePin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            pino = reusablePin
        } else {
            pino = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if let contato = annotation as? Contato {
            
            pino.pinTintColor = UIColor.red
            pino.canShowCallout = true
            let frame = CGRect( x: 0.0, y: 0.0, width: 32.0, height: 32.0)
            let imagemContato = UIImageView(frame: frame )
            
            imagemContato.image = contato.foto
            
            pino.leftCalloutAccessoryView = imagemContato
            
        }
        
        return pino
    }

    // DESAFIO: Apostila - item 5 do exercício 16.13 - página 206
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // recupera o pino que foi selecionado
        let pinToZoomOn = view.annotation
        
        mapView.showAnnotations([pinToZoomOn!], animated: true)
        mapView.selectAnnotation(pinToZoomOn!, animated: true)

//        // Para dar zoom, se fosse anotação individual
//        mapView.selectAnnotation(pinToZoomOn!, animated: true)
//        
//        // opcionalmente, define os limites do zoom
//        let span = MKCoordinateSpanMake(0.5, 0.5)
//        
//        // ou utilize o zoom corrente e centralize o mapa
//        //let span = mapView.region.span
//        
//        // agora move o mapa
//        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
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
