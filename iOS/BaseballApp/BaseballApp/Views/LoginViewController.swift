//
//  LoginViewController.swift
//  BaseballApp
//
//  Created by Ador on 2021/05/13.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=6c8240ec73fc69e81d92&scope=user:email")!
    let callbackUrlScheme = "baseball"
    var authenticationSession: ASWebAuthenticationSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func auth() {
        authenticationSession = ASWebAuthenticationSession.init(url: authURL, callbackURLScheme: callbackUrlScheme, completionHandler: { (callbackURL: URL?, error: Error?) in
            guard error == nil,
                  let callbackURL = callbackURL,
                  let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
                  let code = queryItems.first(where: { $0.name == "code" })?.value else {
                print("An error occurred when attempting to sign in.")
                return
            }
            print(code)
            self.requestAccessToken(with: code)
        })
        authenticationSession?.presentationContextProvider = self
        authenticationSession?.start()
    }
    
    private func requestAccessToken(with code: String) {
        let query = URLQueryItem(name: "code", value: code)
        guard let url = Endpoint.url(path: Endpoint.Path.login, queryItem: [query]) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil, let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            if let jsonData = json as? [String: Any] {
                guard let jwt = jsonData["data"] as? String else {
                    // error handle
                    return
                }
                UserDefaults.standard.set(jwt, forKey: "jwt")
            }
        }).resume()
    }
    
    @IBAction func login() {
        auth()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
