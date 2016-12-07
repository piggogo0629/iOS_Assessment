//
//  ViewController.swift
//  issue4
//
//  Created by Ollie on 2016/12/6.
//  Copyright © 2016年 Ollie. All rights reserved.
//
// http://stackoverflow.com/questions/28152526/how-do-i-open-phone-settings-when-a-button-is-clicked-ios
// http://stackoverflow.com/questions/30987986/ios-9-not-opening-instagram-app-with-url-scheme

import UIKit
import MessageUI

class ViewController: UIViewController {

    //MARK: - Variable
    let labelTextArray = ["顯示一個AlertView", "顯示藍色, 點擊之後變成紅色, 再次點擊之後又變成藍色",
                          "透過CoreMotion顯示使用者現在的步數, 並且即時更新", "開啟此App在iOS設定的頁面",
                          "打開Google Map App或Web導航至alpha camp", "開啟信箱並填上標題\"測試信件\"",
                          "", ""]
    
    //MARK: - @IBOutlet
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //MARK: - Self func
    override func viewDidLoad() {
        super.viewDidLoad()
       
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        // UICollectionView和UITableView最大的不同在於 UICollectionViewLayout
        // UICollectionViewLayout可以说是UICollectionView的大腦中樞，它負責了將各個cell、Supplementary View和Decoration Views進行組織，為它們設定各自的屬性。包括位置、尺寸、層級、形狀等等。
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cellWidth = self.view.frame.width / 2
        // 设置所有cell的size 
        // itemSize 它定義了每一個item的大小。通過设定itemSize可以全局地改變所有cell的尺寸，如果想要對某個cell制定尺寸，可以使用sizeForItemAtIndexPath indexPath:方法。
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = 0.0  //上下間距
        layout.minimumInteritemSpacing = 0.0 //左右間距
        
        myCollectionView.setCollectionViewLayout(layout, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User defined Method
    func openGoogleMaps() {
        // AC: 104台灣台北市中山區南京東路二段97號 ; 25.0522894, 121.53225900000007
        // comgooglemaps://?saddr=Google+Inc,+8th+Avenue,+New+York,+NY&daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&directionsmode=transit
        
        // info.plist add:
        // <key>LSApplicationQueriesSchemes</key>
        // <array>
        //     <string>comgooglemaps</string>
        // </array>
        
        var urlScheme = URL(string: "comgooglemaps://")
        
        if UIApplication.shared.canOpenURL(urlScheme!) {
            
            urlScheme = URL(string: "comgooglemaps://?saddr=&daddr=25.0522894,121.53225900000007&directionsmode=transit")
            
            UIApplication.shared.open(urlScheme!, options: [:], completionHandler: nil)
        } else  {
            print("can't use google map App")
        }
    }
}

// MARK:- UICollectionView Delegate, DataSource, FlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelTextArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            let alertController = UIAlertController(title: "Alert", message: "say something", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            break
        case 1:
            let cell = collectionView.cellForItem(at: indexPath)
            
            if cell?.backgroundColor == UIColor.blue {
                cell?.backgroundColor = UIColor.red
            } else {
                cell?.backgroundColor = UIColor.blue
            }
            
            break
        case 2:
            self.performSegue(withIdentifier: "to_PedoMeter", sender: nil)
            
            break
        case 3:
            // Using UIApplicationOpenSettingsURLString
            guard let settingUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingUrl) {
                UIApplication.shared.open(settingUrl, options: [:], completionHandler: { (success: Bool) in
                    print("open App setting")
                })
            }
            
            break
        case 4:
            openGoogleMaps()
            
            break
        case 5:
            let mailController = MFMailComposeViewController()
            
            //note:不是mailController.delegate <- 這是繼承的父類別的property
            mailController.mailComposeDelegate = self
            
            // 先檢查是否可以寄信
            if MFMailComposeViewController.canSendMail() {
                mailController.setSubject("測試信件")
                mailController.setToRecipients(["someonelikeyou0629@gmail.com"])
                mailController.setMessageBody("內文請寫在這", isHTML: false)
                
                self.present(mailController, animated: true, completion: nil)
            }
            
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! myCollectionViewCell
        cell.myLabel.text = labelTextArray[indexPath.row]
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.darkGray.cgColor
        
        if indexPath.row == 1 {
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }
}

// MARK:- MFMailComposeViewControllerDelegate
extension ViewController: MFMailComposeViewControllerDelegate {
    // "didFinishWithResult:" is a method of the MFMailComposeViewControllerDelegate protocol.
    // This method will be automatically called when the mail interface is closed (e.g. user cancels the operation).
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("mailResult:cancelled")
            break
        case .failed:
            print("mailResult:failed")
            break
        case .saved:
            print("mailResult:saved")
            break
        case .sent:
            print("mailResult:sent")
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
