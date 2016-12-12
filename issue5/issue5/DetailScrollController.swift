//
//  DetailScrollController.swift
//  issue5
//
//  Created by Ollie on 2016/12/12.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class DetailScrollController: UIViewController, UIScrollViewDelegate {

    //MARK:- Variable
    var picImage: UIImage?
    var picText: String?
    var myImageView: UIImageView!
    
    //MARK:- @IBOutlet
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myTextField: UITextView!
    
    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()

        myTextField.text = picText!
        myImageView = UIImageView(image: picImage!)
        
        myScrollView.backgroundColor = UIColor.black
        myScrollView.contentSize = myImageView.bounds.size
        myScrollView.delegate = self
        
        myScrollView.addSubview(myImageView)
        
        setZoomScaleForSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setZoomScaleForSize()
    }
    
    //MARK:- UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
    
    //This is called after every zoom action. It tells the delegate that the scroll view’s zoom factor changed.
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize  = myImageView.frame.size
        let scrollViewSize = myScrollView.bounds.size
        
        let verticalPadding: CGFloat!
        let horizontalPadding: CGFloat!
        
        if imageViewSize.height < scrollViewSize.height {
           verticalPadding = (scrollViewSize.height - imageViewSize.height) / 2
        } else {
           verticalPadding = 0
        }
        
        if imageViewSize.width < scrollViewSize.width {
            horizontalPadding = (scrollViewSize.width - imageViewSize.width) / 2
        } else {
            horizontalPadding = 0
        }
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    //MARK:- User defined method
    func setZoomScaleForSize() {
        let scrollViewSize = myScrollView.bounds.size
        let imageViewSize = myImageView.bounds.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        let minScale = min(widthScale, heightScale)
        
        myScrollView.minimumZoomScale = minScale
        myScrollView.zoomScale = minScale
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
