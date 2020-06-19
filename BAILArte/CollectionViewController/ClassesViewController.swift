//
//  ClassesViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 30/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class ClassesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var classesCollectionView: UICollectionView!
    @IBOutlet weak var noInternetView: UIView!
    
    var categories = [Category]()
    var categoriesNumberOfVideos = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("ReloadMain"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func reloadData() {
        print("relload main")
        if InternetConnectionManager.isConnectedToNetwork() {
            noInternetView.isHidden = true
            categories = FirebaseManager.shared.getCategories()
            categoriesNumberOfVideos = FirebaseManager.shared.categoriesNumberOfVideos
            classesCollectionView.reloadData()
        }
        else {
            noInternetView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.headerLabel.text = "Tutoriale"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2 , height: 220)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassColectionViewCell", for: indexPath) as! ClassCollectionViewCell
        cell.updateCell(with: categories[indexPath.row], nrOfVides: categoriesNumberOfVideos[indexPath.row])
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? SeriesViewController {
            if let indexPath = self.classesCollectionView.indexPathsForSelectedItems?.first?.row {
                nextViewController.series = FirebaseManager.shared.getSeries(for: categories[indexPath])
                nextViewController.navigationItem.title = categories[indexPath].name
            }
        }
    }
    
}

