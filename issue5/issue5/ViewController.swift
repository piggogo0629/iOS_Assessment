//
//  ViewController.swift
//  issue5
//
//  Created by Ollie on 2016/12/10.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK:- Variable
    let imagePicker  = UIImagePickerController()
    var picture: UIImage?
    
    var picNameArray = [String]()
    var picTextArray = [String]()
    
    //MRK:- @IBOutlet
    @IBOutlet weak var myTableView: UITableView!
    
    //MRK:- @IBAction
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.estimatedRowHeight = 141.0
        myTableView.rowHeight = UITableViewAutomaticDimension

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        arrayOperate(by: "load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_Add" {
            let destination = segue.destination as! showPicController
            
            destination.picture = picture
            destination.picNameArray = picNameArray
            destination.picTextArray = picTextArray
        } else if segue.identifier == "to_Detail" {
            let destination = segue.destination as! DetailScrollController
            let indexPath = myTableView.indexPathForSelectedRow!
            
            let picUrl = getDocumentsDirectory().appendingPathComponent(picNameArray[indexPath.row])
            if let picImage = UIImage(contentsOfFile: picUrl.path) {
                destination.picImage = picImage
            }
            
            destination.picText = picTextArray[indexPath.row]
        }
    }
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picture = info[UIImagePickerControllerOriginalImage] as? UIImage
    
        self.dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: "to_Add", sender: nil)
        })
    }
    
    //MARK:- User defined Method
    func getDocumentsDirectory() -> URL {
        let docUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = docUrls.first!
        
        return documentDirectory
    }
    
    func arrayOperate(by text: String) {
        let fileName1 = "picNameArray.txt"
        let fileName2 = "picTextArray.txt"
        
        let NameArrayUrl = getDocumentsDirectory().appendingPathComponent(fileName1)
        let TextArrayUrl = getDocumentsDirectory().appendingPathComponent(fileName2)
        
        if text == "load" {
            if FileManager.default.fileExists(atPath: NameArrayUrl.path) == true {
                picNameArray = NSArray(contentsOfFile: NameArrayUrl.path) as! [String]
            }
            if FileManager.default.fileExists(atPath: TextArrayUrl.path) == true {
                picTextArray = NSArray(contentsOfFile: TextArrayUrl.path) as! [String]
            }
        } else if text == "save" {
            // Type要轉換成NSArray才能存檔
            let nsNameArray = NSArray(array: picNameArray)
            let nsTextArray = NSArray(array: picTextArray)
            
            nsNameArray.write(toFile: NameArrayUrl.path, atomically: true)
            nsTextArray.write(toFile: TextArrayUrl.path, atomically: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myTableViewCell
        
        let picUrl = getDocumentsDirectory().appendingPathComponent(picNameArray[indexPath.row])
        
        if let picImage = UIImage(contentsOfFile: picUrl.path) {
            cell.myImageView.image = picImage
        }
        
        cell.myLabel.text = picTextArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 分享按鈕
        let shareRowAction = UITableViewRowAction(style: .default, title: "分享", handler: {(action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            let shareText = self.picTextArray[indexPath.row]
            
            let picUrl = self.getDocumentsDirectory().appendingPathComponent(self.picNameArray[indexPath.row])
            
            if let sharePic = UIImage(contentsOfFile: picUrl.path) {
                let activityController = UIActivityViewController(activityItems: [shareText,sharePic], applicationActivities: nil)
                
                self.present(activityController, animated: true, completion: nil)
            }
        })
        
        //刪除按鈕
        let deleteRowActin = UITableViewRowAction(style: .default, title: "刪除", handler: {(action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            //刪除image file
            let picUrl = self.getDocumentsDirectory().appendingPathComponent(self.picNameArray[indexPath.row])
            
            if FileManager.default.fileExists(atPath: picUrl.path) == true {
                do {
                    try FileManager.default.removeItem(atPath: picUrl.path)
                } catch let error as NSError{
                    print("removeItem error:\(error.localizedDescription)")
                }
            }
            //刪除array item
            self.picNameArray.remove(at: indexPath.row)
            self.picTextArray.remove(at: indexPath.row)

            self.arrayOperate(by: "save")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        shareRowAction.backgroundColor = UIColor(colorLiteralRed: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteRowActin.backgroundColor = UIColor.darkGray
        
        return [shareRowAction, deleteRowActin]
    }
}

