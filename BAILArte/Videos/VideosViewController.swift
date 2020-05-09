//
//  VideosViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 04/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = false
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//               appDelegate.myOrientation = .portrait
//               UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//               appDelegate.myOrientation = .portrait
//               UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        
        cell.update(with: videos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToPlayer(at: indexPath.row)
    }
    
    func goToPlayer(at index: Int) {
        guard let vc = storyboard?.instantiateViewController(identifier: "PlayerVC") as? ViewController else { return }
        
//        self.hidesBottomBarWhenPushed = true
        vc.urlString = videos[index].url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
