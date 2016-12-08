//
//  ViewController.swift
//  
//
//  Created by Ollie on 2016/12/6.
//
//


import UIKit

class ViewController: UIViewController {

    let defaultSession = URLSession(configuration: .default)
    let myCalendar = Calendar.current
    
    @IBAction func sendGetTest(_ sender: UIButton) {
        
        if let getUrl = URL(string: "https://httpbin.org/get") {
            let dataTask = defaultSession.dataTask(with: getUrl, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                if error != nil {
                    print("===error:\(error?.localizedDescription)")
                    return
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let myData = data {
                            
                            do{
                                let result = try JSONSerialization.jsonObject(with: myData, options: [])
                                
                                let resultJSON = result as! [String: Any]
                                    
                                let origin = resultJSON["origin"] as! String
                                    
                                NSLog("===origin:\(origin)")
                                
                            } catch let error as NSError{
                                print("===error:\(error.localizedDescription)")
                            }
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
    }
    
    @IBAction func sendPostTest(_ sender: UIButton) {
        
        if let postUrl = URL(string: "https://httpbin.org/post") {
            var request = URLRequest(url: postUrl)
            let session = URLSession.shared
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // 現在時間
            let startDate = Date()
            // 自訂格式
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startDateString = dateFormatter.string(from: startDate)
            
            let paras = ["time": startDateString]
            
            do {
                let body = try JSONSerialization.data(withJSONObject: paras, options: [])
                request.httpBody = body
            } catch let error as NSError {
                print("===error:\(error.localizedDescription)")
            }
            
            let dataTask = session.dataTask(with: request, completionHandler: { (data: Data?, response:URLResponse?, error: Error?) in
                if error != nil {
                    print("===error:\(error?.localizedDescription)")
                    return
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let myData = data {
                            
                            let endDate = Date()
                            
                            let compareComponents = self.myCalendar.dateComponents([.second, .nanosecond], from: startDate, to: endDate)
                            
                            let spend = Double(compareComponents.nanosecond!) / 1000000000
                            
                            NSLog("spend:花了\(spend)秒")
                            
//                            do{
//                                let result = try JSONSerialization.jsonObject(with: myData, options: [])
//                                
//                                let resultJSON = result as! [String: Any]
//                                
//                                NSLog("===resultJSON:\(resultJSON)")
//                                
//                            } catch let error as NSError{
//                                print("===error:\(error.localizedDescription)")
//                            }
                        }
                    }
                }
            })
        
            dataTask.resume()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
