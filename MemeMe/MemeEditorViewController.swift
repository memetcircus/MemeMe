//
//  ViewController.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 05/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
  
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var actionTopToolBarItem: UIBarButtonItem!
    
    @IBOutlet weak var cancelTopToolBarItem: UIBarButtonItem!
    
    @IBOutlet weak var cameraBottonBarItem: UIBarButtonItem!
    
    @IBOutlet weak var albumBottomBarItem: UIBarButtonItem!
    
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    
    //for preventing toptext to go up when keyboard appears
    var isTopTextFieldTouched: Bool!
    
    var isEditButtonTouchedInDetailViewCont: Bool = false
    
    let textFieldAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName:UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.4
    ]
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == topTextField {
            isTopTextFieldTouched = true
        }
        else{
            isTopTextFieldTouched = false
        }
        
        //clean textfields when editing begins
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    // if nothing is inserted, turn texts to top and bottom
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text.isEmpty{
            if textField == topTextField{
                textField.text = "TOP"
            }
            else{
                textField.text = "BOTTOM"
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let topTextt = self.topText{
//            self.topTextField.text = topTextt
//        }
//        
//        if let bottomTextt = self.bottomText{
//            self.bottomTextField.text = bottomTextt
//        }
//        
//        if let imagee = self.image{
//            self.imagePickerView.image = imagee
//        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        /*
        if appDelegate.memes.count == 0 {
            self.cancelTopToolBarItem.enabled = false
        }else{
            self.cancelTopToolBarItem.enabled = true
        }*/
        
        //if an image is not picked, disable action button
        if let img = imagePickerView.image{
            self.actionTopToolBarItem.enabled = true
        }
        else{
            self.actionTopToolBarItem.enabled = false
        }
        
        //set texts to impact
        topTextField.defaultTextAttributes = textFieldAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.defaultTextAttributes = textFieldAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        //if camera not available, disable camera button
        cameraBottonBarItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
        
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }

    //shift image up to see the bottom entered text
    func keyboardWillShow(notification: NSNotification){
        
        if !isTopTextFieldTouched {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //shift image to original
    func keyboardWillDisappear(notification: NSNotification){
        
        if !isTopTextFieldTouched {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight (notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications(){
       
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification , object: nil)
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
       
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //save memed image and related text to appdelegate array
    func save(passedMemedImage : UIImage) {
        
        var meme = Meme(bottomText: bottomTextField.text, topText: topTextField.text, orgImage: imagePickerView.image!, memedImage: passedMemedImage)
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
 
    
    @IBAction func shareTheMemedImage(sender: AnyObject) {
        
        let memedImage : UIImage = self.generateMemedImage()
        
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        nextController.excludedActivityTypes = [
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(nextController, animated: true, completion: nil)
        
        nextController.completionWithItemsHandler = {(activityType: String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) -> Void in
            if completed {
                self.save(memedImage)
    
                    if self.isEditButtonTouchedInDetailViewCont{
                        self.performSegueWithIdentifier("unwindToDetailView", sender: self)
                        
                    }
                    else
                    {
                        self.dismissViewControllerAnimated(true, completion:nil)
                    }
            }
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        //self.view.backgroundColor = UIColor.clearColor()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
        //self.view.backgroundColor = UIColor.darkGrayColor()
        
        return memedImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imagePickerView.image = image
        }
    
        self.dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    @IBAction func cancelEdit(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    

}

