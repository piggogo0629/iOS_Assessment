//
//  showPicController.swift
//  issue5
//
//  Created by Ollie on 2016/12/11.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class showPicController: UIViewController {

    //MARK:- Variable
    var picture: UIImage?
    var picNameArray = [String]()
    var picTextArray = [String]()

    //MRK:- @IBOutlet
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextField: UITextView!
    
    @IBAction func touchDownToCloseKeyboard(_ sender: UIControl) {
        myTextField.resignFirstResponder()
    }
    
    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()

        //自訂返回動作
        let backButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(backToFront(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        if let myPic = picture {
            myImageView.image = myPic
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- User defined Method
    func getDocumentsDirectory() -> URL {
        let docUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = docUrls.first!
        
        return documentDirectory
    }
    
    func saveData() {
        // 作為存檔名稱
        let interval = Date().timeIntervalSinceReferenceDate
        let imageFileName = "\(interval).jpg"
        
        let imageFileUrl = getDocumentsDirectory().appendingPathComponent(imageFileName)
        
        if let myPic = picture {
            let imageData = UIImageJPEGRepresentation(myPic, 0.8)
            
            do {
                try imageData?.write(to: imageFileUrl)
            } catch let error as NSError {
                print("write error:\(error.localizedDescription)")
            }
        }
        
        picNameArray.append(imageFileName)
        picTextArray.append(myTextField.text)
        
        let fileName1 = "picNameArray.txt"
        let fileName2 = "picTextArray.txt"
        
        let NameArrayUrl = getDocumentsDirectory().appendingPathComponent(fileName1)
        let TextArrayUrl = getDocumentsDirectory().appendingPathComponent(fileName2)
        
        // Type要轉換成NSArray才能存檔
        let nsNameArray = NSArray(array: picNameArray)
        let nsTextArray = NSArray(array: picTextArray)
        
        nsNameArray.write(toFile: NameArrayUrl.path, atomically: true)
        nsTextArray.write(toFile: TextArrayUrl.path, atomically: true)
    }
    
    func backToFront(_ sender: UIBarButtonItem) {
        if myTextField.text != "" {
            saveData()
        } else {
            let alertController = UIAlertController(title: "Alert", message: "請輸入照片描述", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let frontViewController = self.navigationController?.childViewControllers[0] as! ViewController
        
        frontViewController.arrayOperate(by: "load")
        frontViewController.myTableView.reloadData()
        
        let _ = self.navigationController?.popToViewController(frontViewController, animated: true)
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
