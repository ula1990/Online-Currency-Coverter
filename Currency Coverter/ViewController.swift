//
//  ViewController.swift
//  Currency Coverter
//
//  Created by Ulad Daratsiuk-Demchuk on 2017-12-10.
//  Copyright © 2017 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var myCurrency: [String] = []
    var myValues: [Double] = []
    var activeCurrency: Double = 0;
    let defaults = UserDefaults.standard
    
    //Objects
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var output: UILabel!
    
    //Creating a PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
    //RELOAD BUTTON
    
    @IBAction func reloadBut(_ sender: Any) {
        
        let url = URL(string: "http://api.fixer.io/latest")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            //FOR FASTER WORK OF PICKERVIEW
            DispatchQueue.main.async {
                
                if error != nil
                {
                    self.alertUser("Can't download currecies", err: "Please check in internet connection")
                    self.pickerView.isHidden = true
                    
                }
                else{
                    if let content = data
                        
                    {
                        self.pickerView.isHidden = false
                        self.alertUser("Update was performed", err: "You have last rates")
                        do{
                            let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            
                            if let rates = myJson["rates"] as? NSDictionary
                            {
                                
                                for (key,value ) in rates
                                {
                                    self.myCurrency.append((key as? String)!)
                                    self.myValues.append((value as? Double)!)
                                    
                                }
                            }
                        }
                        catch{
                            self.alertUser( "Please check connection", err: "No Internet")
                        }
                    }
                }
                
                self.pickerView.reloadAllComponents()
                
            }
        }
        task.resume()
        
        
    }
    
    
    //  CONVERT BUTTON
    
    @IBAction func convertButton(_ sender: Any) {
        if (input.text != ""){
            output.text = "Result: " + String(Double(input.text!)! * activeCurrency)
            
        }else{
            
            output.text = "Please correct amount.."
        }
        
        input.resignFirstResponder()
    }
    
    
    
    //SHARE BUTTON
    @IBAction func shareButton(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: ["Take a look on this amazing currency coverter "], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
        
    }
    
    
    //ALERT FUNCTION FOR MESSAGES
    
    func alertUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //FUNCTION FOR UITEXTFIELD
        
      
          
        
        // Do any additional setup after loading the view, typically from a nib.
        //GETTING DATA
        let url = URL(string: "http://api.fixer.io/latest")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            //FOR FASTER WORK OF PICKERVIEW
            DispatchQueue.main.async {
              
            if error != nil
            {
             self.alertUser("Can't download currecies", err: "Please check in internet connection")
                self.pickerView.isHidden = true
             
            }
            else{
                if let content = data
                    
                {
                    self.pickerView.isHidden = false
                    do{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                       
                        
                        if let rates = myJson["rates"] as? NSDictionary
                        {
                           
                            for (key,value ) in rates
                            {
                                self.myCurrency.append((key as? String)!)
                                self.myValues.append((value as? Double)!)
                                
                            }
                        /*    print(self.myCurrency)
                            print(self.myValues) */
                        }
                    }
                    catch{
                        self.alertUser( "Please check connection", err: "No Internet")
                    }
                }
                self.pickerView.reloadAllComponents()
            }

            
            self.pickerView.reloadAllComponents()
       
        }
        }
        task.resume()
        
        
        let iconImageView = UIImageView(image: UIImage(named: "cash" ))
        self.navigationItem.titleView = iconImageView
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    
    
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


}

