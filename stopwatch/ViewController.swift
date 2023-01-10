//
//  ViewController.swift
//  stopwatch
//
//  Created by Ann Robles on 1/9/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var hourMinuteSecondLabel: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    
    var timer: Timer = Timer()
    var timerCounting: Bool = false
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var dataSourceArr = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       lapsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dataSourceArr = []
    }
    
    
    @IBAction func startStopTapped(_ sender: Any) {

        if (timerCounting) {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
            lapResetButton.setTitle("Reset", for: .normal)
        }
        else {
            timerCounting = true
            startStopButton.setTitle("Stop", for: .normal)
            lapResetButton.setTitle("Lap", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
        }
    }
    
    
    @IBAction func lapResetTapped(_ sender: Any) {
        
        if (timerCounting) {
            
            var lapTime = ""
            lapTime += hourMinuteSecondLabel.text ?? ""
            lapTime += fractionLabel.text ?? ""
            
            dataSourceArr.insert(lapTime, at: dataSourceArr.count)
            lapsTableView.reloadData()
        }
        else {
            lapResetButton.setTitle("Lap", for: .normal)
            timer.invalidate()
            (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
            hourMinuteSecondLabel.text = "00:00:00"
            fractionLabel.text = ".00"
        }
    }
  
    @objc func keepTimer() {
        
        fractions += 1
        if fractions > 99 {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        hourMinuteSecondLabel.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        fractionLabel.text = ".\(fractions)"
    }
    
}

extension ViewController : UITableViewDelegate{

}

extension ViewController : UITableViewDataSource{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSourceArr[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
}
