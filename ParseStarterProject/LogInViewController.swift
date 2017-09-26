/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class LogInViewController: UIViewController {
    struct ScreenMode {
        public static let signUp:String = "SignUp";
        public static let logIn:String = "LogIn";
    }
    var screenMode:String = ScreenMode.signUp;
    var activityIndicator:UIActivityIndicatorView?;
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var changeSignupOrLoginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func signupOrLoginButtonAction(_ sender: Any) {
          if usernameTextField.text == String() || passwordTextField.text == String() {
            let errorMessage = " Fill in all the details to signup. ";
            presentAlertControl(withTitle:  "Error in Form", message: errorMessage);
        } else if screenMode == ScreenMode.signUp {
            startActivityIndicator();
            print("user is tring to signup. // SignUP Mode");
            /* signing up new user. */
            let user = PFUser();
            user.username = usernameTextField.text!;
            user.password = passwordTextField.text!;
            user.signUpInBackground(block: { (success, error) in
                self.stopActivityIndicator();
                if let _error = error {
                    let errorMsg = _error.localizedDescription;
                    self.presentAlertControl(withTitle: "Error signing up", message: errorMsg);
                } else if success {
                    print(" user successfully signedup. ");
                    self.performSegue(withIdentifier: "loginToUsers", sender: self);
                }
            })
        } else if screenMode == ScreenMode.logIn {
            print(" user is trying to Login. // LogIn mode ");
            startActivityIndicator();
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                self.stopActivityIndicator();
                if let _error = error {
                    print("Error Logging in");
                    self.presentAlertControl(withTitle: "Error Logging In", message: _error.localizedDescription )
                } else  if let _user = user {
                    print(" congratulations! \(_user.username!) sucessfully Logged In");
                    print("current userInfo: \(_user)");
                    self.performSegue(withIdentifier: "loginToUsers", sender: self);
                }
            })
        }
    }
    
    // MARK: navigation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _segueIdentifier = segue.identifier  {
            if _segueIdentifier == "loginToUsers" {
                if segue.destination is UINavigationController {
                    let query = PFUser.query();
                    query?.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
                    print("Looking for records with objectId: \(PFUser.current()!.objectId!)");
                    query?.findObjectsInBackground(block: { (objects, error) in
                        if let  _error = error {
                            print("Error: \(_error.localizedDescription)")
                        } else {
                            print(" result : \(objects!.count)")
                        }
                    })
                }else {
                    print(" other segue.  \(segue.destination)");
                }
            }
        }
    }
    
    
    func presentAlertControl(withTitle:String, message:String){
        let ac = UIAlertController(title: withTitle, message: message, preferredStyle: .alert);
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil);
        }) );
        self.present(ac, animated: true, completion: nil);
    }
    
    func startActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
        if let _activityIndicator = activityIndicator {
            _activityIndicator.center = self.view.center;
            _activityIndicator.hidesWhenStopped = true;
            _activityIndicator.activityIndicatorViewStyle = .gray;
            self.view.addSubview(_activityIndicator);
            _activityIndicator.startAnimating();
            UIApplication.shared.beginIgnoringInteractionEvents();
        }
    }
    
    func stopActivityIndicator() {
        if let _activityIndicator = activityIndicator {
            _activityIndicator.stopAnimating();
            UIApplication.shared.endIgnoringInteractionEvents();
        }
    }
    
    
    @IBAction func chnageSignupOrLoginButtonAction(_ sender: Any) {
        if screenMode == ScreenMode.signUp {
            signupOrLoginButton.setTitle("LogIn", for: .normal);
            changeSignupOrLoginButton.setTitle("SignUp", for: .normal)
            screenMode = ScreenMode.logIn;
            messageLabel.text = "Don't have an account ?";
        } else if screenMode == ScreenMode.logIn {
            signupOrLoginButton.setTitle("SignUP", for: .normal);
            changeSignupOrLoginButton.setTitle("LogIn", for: .normal)
            screenMode = ScreenMode.signUp;
            messageLabel.text = "Already have an account ?";
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if PFUser.current()  != nil {
//            self.performSegue(withIdentifier: "loginToUsers", sender: self);
//        }
        self.navigationController?.navigationBar.isHidden = true;
        print("text color: \(String(describing: self.usernameTextField.textColor))");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
