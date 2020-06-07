//
//  FeedbackViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 09/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import TPKeyboardAvoidingSwift
import FirebaseFirestoreSwift
import FirebaseFirestore

class FeedbackViewController: UIViewController, UITableViewDataSource, FeedbackTableViewCellDelegate {
    @IBOutlet private var tableView: TPKeyboardAvoidingTableView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noInternetStackView: UIStackView!
    
    private var questionsArray = [String]()
    private var answersArray = [Answer]()
    let alertservice = AlertService()
    var clearTextfield = false
    var selectedIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !RequestManager.shared.noInternet {
            noInternetView.isHidden = true
            noInternetStackView.isHidden = true
            
            createEmptyAnswersArray()
        }
        else {
            
        }
        
    }
    
    func createEmptyAnswersArray() {
        questionsArray = FirebaseManager.shared.getFeedback()
        for question in questionsArray {
            let answer = Answer(question: question, answer: "")
            answersArray.append(answer)
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        selectedIndex = indexPath
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        cell.feedbackTableViewCellDelegate = self
        cell.update(with: questionsArray[indexPath.row], clearTextField: clearTextfield, at: indexPath.row)
        
        return cell
    }
    
    func setAnswer(_ feedbackTableViewCell: FeedbackTableViewCell, answer: String, to questionAtindex: Int) {
        answersArray[questionAtindex].answer = answer
    }
    
    
    @IBAction func sendFeedback(_ sender: UIButton) {
        view.endEditing(true)
        
        let db = Firestore.firestore()
        let ref = db.collection("feedback").document("ios")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myDict = self.answersArray.reduce(into: [String: String] ()) {
            $0[$1.question] = $1.answer
        }
        
        ref.setData([formatter.string(from: Date.init()) : myDict], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.clearTextfield = true
                self.tableView.reloadData()
                
                let alert = self.alertservice.simpleAlert() { [weak self] in
                    self?.tabBarController?.selectedIndex = 0
                }
                
                self.present(alert, animated: true)
                print("Document successfully written!")
            }
        }
        
    }
    
}


