//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Vinay Reddy Polati on 9/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit;
import Parse;

@available(iOS 10.0, *)
class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    struct PostKeys {
        public static let userObjectId:String = "userObjectId";
        public static let message:String = "message";
        public static let image:String = "image";
    }
    
    var activityIndicator:UIActivityIndicatorView?;
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var messageTextField: UITextField!

    @IBAction func cameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self;
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false;
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        startActivityIndicator();
        let postObject = PFObject(className: "Posts");
        postObject[PostKeys.userObjectId] = PFUser.current()?.objectId!;
        postObject[PostKeys.message] = messageTextField.text;
        if let _img = self.imageview.image {
            if let _image  = UIImageJPEGRepresentation(_img, 0.5)   {
                  postObject[PostKeys.image] = PFFile(data: _image);
                postObject.saveInBackground(block: { (success, error) in
                    self.stopActivityIndicator();
                    if let _error = error {
                        print("Error saving post object. \(_error.localizedDescription)");
                    } else if success {
                        print("congrats! image successfully posted.");
                    }
                })
            }
        } else {
            print("ErrorInfo: select a image to post.");
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let _image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageview.image = _image;
        } else {
            print("Error, problem getting image. ");
        }
        self.dismiss(animated: true, completion: nil);
    }
    
    func startActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
        if let _spinner = activityIndicator {
            _spinner.center = self.view.center;
            _spinner.hidesWhenStopped = true;
            _spinner.activityIndicatorViewStyle = .gray;
            self.view.addSubview(_spinner);
            _spinner.startAnimating();
            UIApplication.shared.beginIgnoringInteractionEvents();
        }
    }
    
    func stopActivityIndicator(){
        if let _spinner = activityIndicator {
            _spinner.stopAnimating();
            UIApplication.shared.endIgnoringInteractionEvents();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let _color = UIColor(displayP3Red: 0.66427, green: 0.664286, blue: 0.664277, alpha: 1);
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : _color,
                    NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 20.0)!,];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
