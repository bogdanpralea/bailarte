//
//  LoginViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 02/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import CryptoKit
import AuthenticationServices
import FirebaseUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appleView: UIView!
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        //MAYBE CHECK THIS IN APPDELEGATE
        
        // on the initial view controller or somewhere else, check the userdefaults
        if let userID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") {
                
            // get the login status of Apple sign in for the app
               // asynchronous
            if #available(iOS 13.0, *) {
                ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
                    credentialState, error in
                    
                    switch(credentialState){
                    case .authorized:
                        print("user remain logged in, proceed to another view")
                        self.goToHome()
                    case .revoked:
                        print("user logged in before but revoked")
                    case .notFound:
                        print("user haven't log in before")
                    default:
                        print("unknown state")
                    }
                })
            } else {
                // Fallback on earlier versions
            }
        }
                
      
        if #available(iOS 13.0, *) {
            let siwaButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
            
            siwaButton.translatesAutoresizingMaskIntoConstraints = false
                   appleView.addSubview(siwaButton)
                   
                   NSLayoutConstraint.activate([
                       siwaButton.leadingAnchor.constraint(equalTo: appleView.leadingAnchor, constant: 0),
                       siwaButton.trailingAnchor.constraint(equalTo: appleView.trailingAnchor, constant: 0),
                       siwaButton.bottomAnchor.constraint(equalTo: appleView.bottomAnchor, constant: 0),
                       siwaButton.topAnchor.constraint(equalTo: appleView.topAnchor, constant: 0)
                      ])
                   

                       siwaButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
                  

        } else {
            // Fallback on earlier versions
        }
       
//        let authUI = FUIAuth.defaultAuthUI()
//        // You need to adopt a FUIAuthDelegate protocol to receive callback
//        authUI.delegate = self
//
//        let provider = FUIOAuth.appleAuthProvider()
//        let providers: [FUIAuthProvider] = [
//          FUIFacebookAuth(),
////          FUIOAuth.appleAuthProvider()
//        ]
//        self.authUI.providers = providers
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Register to Apple ID credential revoke notification
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateDidRevoked(_:)), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            NotificationCenter.default.removeObserver(self, name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func appleIDStateDidRevoked(_ notification: Notification) {
        // Make sure user signed in with Apple
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if let providerId = currentUser.providerData.first?.providerID,
            providerId == "apple.com" {
            try? signOut()
        }
    }
    
    @available(iOS 13.0, *)
    func putThisInAppDelegateIfNeeded() {
        // Retrieve user ID saved in UserDefaults
        if let userID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") {
            
            // Check Apple ID credential state
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: { [unowned self]
                credentialState, error in
                
                switch(credentialState) {
                case .authorized:
                    break
                case .notFound,
                     .transferred,
                     .revoked:
                    // Perform sign out
                    try? self.signOut()
                    break
                @unknown default:
                    break
                }
            })
        }
    }
    
    func signOut() throws {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        // Check provider ID to verify that the user has signed in with Apple
        if let providerId = currentUser.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        }
        
        // Perform sign out from Firebase
        try? Auth.auth().signOut()
   
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        goToHome()
    }

    @IBAction func fbButtonPressed(_ sender: UIButton) {
        goToHome()
    }
    
    @available(iOS 13, *)
    @objc func appleSignInTapped() {
        startSignInWithAppleFlow()
    }
    
    func goToHome() {
        self.present(storyBoardName: "Main", controllerId: "HomeId")
    }
    
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController : ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }

        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // unique ID for the user
              let userID = appleIDCredential.user
            
              // save it to user defaults
              UserDefaults.standard.set(userID, forKey: "appleAuthorizedUserIdKey")
            
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            
            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
              if let error = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error.localizedDescription)
                return
              }
                
                // Mak a request to set user's display name on Firebase
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                changeRequest?.commitChanges(completion: { (error) in

                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
                    }
                })
                
                print("signed in")
                self?.goToHome()
              // User is signed in to Firebase with Apple.
              // ...
            }
        }
    }
}

//apple sign in
@available(iOS 13.0, *)
extension LoginViewController {
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    func reauthenticateWithCredential() {
    // Initialize a fresh Apple credential with Firebase.
//    let credential = OAuthProvider.credential(
//      withProviderID: "apple.com",
//      IDToken: appleIdToken,
//      rawNonce: rawNonce
//    )
//    // Reauthenticate current Apple user with fresh Apple credential.
//    Auth.auth().currentUser.reauthenticate(with: credential) { (authResult, error) in
//      guard error != nil else { return }
//      // Apple user successfully re-authenticated.
//      // ...
//    }
    }
}


