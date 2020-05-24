//
//  ContactViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 09/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet private var mapViewS: MKMapView!
    @IBOutlet private var mapViewC: MKMapView!
    
    let firstContactNumber = "0747171850"
    let secondContactnumber = "0744139532"
    let contactEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMaps()
    }
    
    func setupMaps() {
        mapViewC.centerToLocation(CLLocation(latitude: 46.7720494, longitude: 23.6035172))
        
        let annotationC = MKPointAnnotation()
        annotationC.title = "BAILArte Club"
        annotationC.coordinate = CLLocationCoordinate2D(latitude: 46.7720494, longitude: 23.6035172)
        mapViewC.addAnnotation(annotationC)

        mapViewS.centerToLocation( CLLocation(latitude: 46.7812757, longitude: 23.6082624))
        
        let annotationS = MKPointAnnotation()
        annotationS.title = "BAILArte Studio"
        annotationS.coordinate = CLLocationCoordinate2D(latitude: 46.7812757, longitude: 23.6082624)
        mapViewS.addAnnotation(annotationS)
    }
    
    func call(number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["bailarte.salsa@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func callFirstContact(_ sender: UIButton) {
        call(number: firstContactNumber)
        
    }
    
    @IBAction func callSecondContact(_ sender: UIButton) {
        call(number: secondContactnumber)
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        sendEmail()
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
