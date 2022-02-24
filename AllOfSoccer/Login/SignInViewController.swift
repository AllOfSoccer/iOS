//
//  LoginViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/06/13.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var signInView: UIView?

    // viewmodel 브랜치안에 login 관련 코드가 있어 나중에 충돌이 발생할 수 있으므로 주석처리 해놓음
    // 추후 사용할거임
//    @IBAction func login() {
//        AuthApi.shared.loginWithKakaoAccount { oauthToken, error in
//            if let error = error {
//                print(error)
//            } else {
//                print("loginWithKakaoAccount() success.")
//                // do something
//                _ = oauthToken
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton()
    }

    func addButton() {
        guard let signInView = self.signInView else { return }

        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(handleAppleSignButton), for: .touchUpInside)
        signInView.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: signInView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: signInView.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: signInView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: signInView.bottomAnchor).isActive = true
    }

    @objc func handleAppleSignButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authString: \(authString)")
                print("tokenString: \(tokenString)")
            }

            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")

//        case let passwordCredential as ASPasswordCredential:
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            print("username: \(username)")
//            print("password: \(password)")
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("로그인에 실패했습니다.")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
