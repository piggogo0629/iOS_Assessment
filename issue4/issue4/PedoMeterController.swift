//
//  PedoMeterController.swift
//  issue4
//
//  Created by Ollie on 2016/12/7.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreMotion
// info.plist add : Privacy - Motion Usage Description

class PedoMeterController: UIViewController {
    
    // MARK:- Variable
    let pedometer = CMPedometer()
    
    // MARK:- @IBOutlet
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var cadenceLabel: UILabel!
    @IBOutlet weak var floorsAscendLabel: UILabel!
    @IBOutlet weak var floorsDescendLabel: UILabel!
    
    // MARK:- @IBAction
    @IBAction func startTracking(_ sender: UIButton) {
        //That code will basically get the current day from Midnight 00:00:00 time. Because I want to find out all the steps which I have done today.
        var cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comps.hour   = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = TimeZone.ReferenceType.local
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: comps)!
        
        pedometer.startUpdates(from: midnightOfToday, withHandler: {
            (pedometerData: CMPedometerData?, error: Error?) -> Void in
            if error == nil {
                DispatchQueue.main.async {
                    self.updateInfo(with: pedometerData!)
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        })
    }
    
    @IBAction func stopTracking(_ sender: UIButton) {
        pedometer.stopUpdates()
    }
    
    // MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()

//        if(CMPedometer.isStepCountingAvailable()){
//            let fromDate = Date(timeIntervalSinceNow: -86400 * 7)
//            pedometer.queryPedometerData(from: fromDate, to: Date(), withHandler: { (data: CMPedometerData?, error: Error?) in
//                
//                DispatchQueue.main.async {
//                    self.updateInfo(with: data!)
//                }
//                
//            })
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- User defined Method
    func updateInfo(with pedometerData: CMPedometerData) {
        // step counting
        if CMPedometer.isStepCountingAvailable() {
            print("numberOfSteps:\(pedometerData.numberOfSteps)")
            stepCountLabel.text = "Steps walked: \(pedometerData.numberOfSteps)"
        } else {
            stepCountLabel.text = "Step Counter not available"
        }
        
        // distance
        if CMPedometer.isDistanceAvailable() {
            print("distance:\(pedometerData.distance)")
            distanceLabel.text = "Distance travelled: \(pedometerData.distance) meters"
        } else {
            distanceLabel.text = "Distance estimate not available"
        }
        
        // pace
        if CMPedometer.isPaceAvailable() && pedometerData.currentPace != nil {
            print("currentPace:\(pedometerData.currentPace)")
            paceLabel.text = "Current Pace: \(pedometerData.currentPace) seconds per meter"
        } else {
            paceLabel.text = "Pace not available.";
        }
        
        // cadence
        if CMPedometer.isCadenceAvailable() && pedometerData.currentCadence != nil {
            print("currentCadence:\(pedometerData.currentPace)")
            cadenceLabel.text = "Cadence: \(pedometerData.currentCadence) steps per second"
        } else {
            self.cadenceLabel.text = "Cadence not available"
        }
        
        // floorsAscended
        if CMPedometer.isFloorCountingAvailable() && pedometerData.floorsAscended != nil {
            floorsAscendLabel.text = "Floors ascended: \(pedometerData.floorsAscended)"
        } else {
            floorsAscendLabel.text = "Floors ascended not available"
        }
        
        // floorsDescended
        if CMPedometer.isFloorCountingAvailable() && pedometerData.floorsDescended != nil {
            floorsDescendLabel.text = "Floors descended: \(pedometerData.floorsDescended)"
        } else {
            floorsDescendLabel.text = "Floors descended not available"
        }
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
