//
//  SeriesViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 09/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var series = [Series]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "191839")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        
        cell.update(with: series[indexPath.row])
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? VideosViewController {
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                nextViewController.videos = FirebaseManager.shared.getVideos(for: series[indexPath.row])
                nextViewController.navigationItem.title = series[indexPath.row].name
            }
        }
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}



