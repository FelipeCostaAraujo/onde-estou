//
//  ViewController.swift
//  Onde Estou
//
//  Created by Felipe Araujo on 08/12/19.
//  Copyright © 2019 Felipe Araujo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            print("Nao autorizado")
            let alertController = UIAlertController(title: "Permissão de localização", message: "Necessario permissão para acesso à sua localizão!! por favir habilite.", preferredStyle: .alert)
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default) { (alertaConfiracoes) in
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            }
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController,animated: true,completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacaoUsuario: CLLocation = locations.last!
        
        let longitude = localizacaoUsuario.coordinate.longitude
        let latitude = localizacaoUsuario.coordinate.latitude
        
        longitudeLabel.text = String(format: "%f", longitude)
        latitudeLabel.text = String(format: "%f", latitude)
        
        if localizacaoUsuario.speed > 0 {
             velocidadeLabel.text = String(format:"%0.1f", localizacaoUsuario.speed)
        }
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
        let areaVisualizacao:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: location, span: areaVisualizacao)
               
        map.setRegion(regiao , animated: true)
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, erro) in
            if erro == nil {
                if let dadosLocal = detalhesLocal?.first {
                    var thoroughfare = ""
                    var subThoroughfare = ""
                    var locality = ""
                    var subLocality = ""
                    var postalCode = ""
                    var country = ""
                    var administrativeArea = ""
                    var subAdministrativeArea = ""
                    
                    if dadosLocal.thoroughfare != nil {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    if dadosLocal.subLocality != nil {
                        subLocality = dadosLocal.subLocality!
                    }
                    if dadosLocal.postalCode != nil {
                        postalCode = dadosLocal.postalCode!
                    }
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
                    if dadosLocal.administrativeArea != nil {
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    if dadosLocal.subAdministrativeArea != nil {
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    self.enderecoLabel.text = thoroughfare + " ," + subThoroughfare + "\n" + subLocality + " / " + locality + "\n" + administrativeArea + " - " + country
                    
                    print("\n /"+thoroughfare +
                          "\n /"+subThoroughfare +
                          "\n /" + locality +
                          "\n /" + subLocality +
                          "\n /" + postalCode +
                          "\n /" + country +
                          "\n /" + administrativeArea +
                          "\n /" + subAdministrativeArea)
                }
            }else{
                print("não foi possivel exibir o endereço")
            }
        }
        
    }


}

