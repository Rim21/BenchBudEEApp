//
//  BenchBudEEViewController.swift
//  BenchBudEE
//
//  Created by Rim21 on 31/12/2014.
//  Copyright (c) 2014 Nathan Rima. All rights reserved.
//

import UIKit


class BenchBudEEViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, centralData  {

    
    let bleInstance = BenchBudEECentral()
    
    @IBOutlet weak var metalBgnd: UIImageView!
    @IBOutlet weak var mainDisplay: UIImageView!
    @IBOutlet weak var ADCLbl: UILabel!
    @IBOutlet weak var LEDLbl: UILabel!
    @IBOutlet weak var DACLbl: UILabel!
    @IBOutlet weak var ADCValue: UILabel!
    @IBOutlet weak var LEDValue: UILabel!
    @IBOutlet weak var DACValue: UILabel!
    @IBOutlet weak var ADCUnit: UILabel!
    @IBOutlet weak var LEDUnit: UILabel!
    @IBOutlet weak var DACUnit: UILabel!
    @IBOutlet weak var TempValue: UILabel!
    @IBOutlet weak var BLEValue: UILabel!
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var BLEBtn: UIButton!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var g10Btn: UIButton!
    @IBOutlet weak var g100Btn: UIButton!
    @IBOutlet weak var g1kBtn: UIButton!
    @IBOutlet weak var relayBtn: UIButton!
    @IBOutlet weak var selectorBgnd: UIImageView!
    @IBOutlet weak var ADCBtn: UIButton!
    @IBOutlet weak var LEDBtn: UIButton!
    @IBOutlet weak var DACBtn: UIButton!
    @IBOutlet weak var settingDisplay: UIImageView!
    @IBOutlet weak var byPassBtn1: UIButton!
    @IBOutlet weak var byPassBtn2: UIButton!
    @IBOutlet weak var selectorBtn: UIButton!
    @IBOutlet weak var gradarii: UIImageView!
    @IBOutlet weak var ADCSetTitle: UILabel!
    @IBOutlet weak var ADCSetValue: UILabel!
    @IBOutlet weak var ADCSetUnit: UILabel!
    @IBOutlet weak var LEDSetValue: UILabel!
    @IBOutlet weak var LEDSetUnit: UILabel!
    @IBOutlet weak var LEDSetTitle: UILabel!
    @IBOutlet weak var DACSetTitle: UILabel!
    @IBOutlet weak var DACSetValue: UILabel!
    @IBOutlet weak var DACSetUnit: UILabel!
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var valueTitle: UILabel!
    @IBOutlet weak var voiceLbl: UILabel!
    @IBOutlet weak var relayLbl: UILabel!
    @IBOutlet weak var BLELbl: UILabel!
    @IBOutlet weak var powerLbl: UILabel!
    @IBOutlet weak var ByP1Lbl: UILabel!
    @IBOutlet weak var ByP2Lbl: UILabel!
    @IBOutlet weak var BBLbl: UILabel!
    @IBOutlet weak var Ch0Btn: UIButton!
    @IBOutlet weak var Ch0Lbl: UILabel!
    
    @IBOutlet weak var settingSlider: UISlider!
    @IBOutlet weak var ADCSlider: UISlider!
    @IBOutlet weak var LEDSlider: UISlider!
    @IBOutlet weak var DACSlider: UISlider!
    
    @IBOutlet weak var BBTable: UITableView!
    @IBOutlet weak var BBTableBgnd: UIImageView!
    
    
    @IBAction func powerBtnAct(sender: UIButton) {
        //check for double presses
        if(!bleInstance.readyBLE){
            println("On\n")
            bleInstance.powerOn()
            bleInstance.readyBLE = true
            sender.selected = !sender.selected
        } else {
            println("Off\n")
            bleInstance.readyBLE = false
            sender.selected = !sender.selected
            BBTable.hidden = false
            BBTableBgnd.hidden = false
            Ch0Btn.selected = false
            
            bleInstance.buf = [0x04]
            bleInstance.transmit()
            bleInstance.cleanup()
        }
    }
    @IBAction func BLEBtnAct(sender: UIButton) {
        sender.selected = !sender.selected
        bleInstance.buf = [0xC0, 0x00, 0x00]
        if (sender.selected){
            bleInstance.buf[1] = 0x01
        }else{
            bleInstance.buf[1] = 0x00
        }
        bleInstance.transmit()
    }
    @IBAction func voiceBtnAct(sender: UIButton) {
        
    }
    @IBAction func Ch0Btn(sender: UIButton) {

    }
    
    
    @IBAction func g10BtnAct(sender: UIButton) {
        sender.selected = !sender.selected
    }
    @IBAction func g100BtnAct(sender: UIButton) {
        sender.selected = !sender.selected
    }
    @IBAction func g1kBtnAct(sender: UIButton) {
        sender.selected = !sender.selected
    }
    @IBAction func relayBtnAct(sender: UIButton) {
        sender.selected = !sender.selected
        bleInstance.buf = [0x01, 0x00, 0x00]
        if (sender.selected){
            bleInstance.buf[1] = 0x01
            //displayInfoOutput("On\n \(buf)\n")
        }else{
            bleInstance.buf[1] = 0x00
            // displayInfoOutput("Off\n \(buf)\n")
        }
        bleInstance.transmit()

    }
    @IBAction func ADCBtnAct(sender: UIButton) {
        var buttons = [ADCBtn, LEDBtn, DACBtn]
        for button in buttons {
            if (button == sender) {
                if (sender.selected){
                    button.selected = false
                    valueTitle.hidden = true
                    settingTitle.hidden = false
                    settingSlider.hidden = false
                    
                    if (sender == ADCBtn) {
                        ADCSetTitle.hidden = true
                        ADCSlider.hidden = true
                        ADCSetValue.hidden = true
                        ADCSetUnit.hidden = true
                        
                    }
                    else if (sender == LEDBtn) {
                        LEDSetTitle.hidden = true
                        LEDSlider.hidden = true
                        LEDSetValue.hidden = true
                        LEDSetUnit.hidden = true
                    }
                    else if (sender == DACBtn) {
                        DACSetTitle.hidden = true
                        DACSlider.hidden = true
                        DACSetValue.hidden = true
                        DACSetUnit.hidden = true
                    }
                }
                else {
                    button.selected = true
                    settingTitle.hidden = true
                    valueTitle.hidden = false
                    
                    if (sender == ADCBtn) {
                        ADCSetTitle.hidden = false
                        ADCSlider.hidden = false
                        ADCSetValue.hidden = false
                        ADCSetUnit.hidden = false
                        
                        LEDSetTitle.hidden = true
                        LEDSlider.hidden = true
                        LEDSetValue.hidden = true
                        LEDSetUnit.hidden = true
                        
                        DACSetTitle.hidden = true
                        DACSlider.hidden = true
                        DACSetValue.hidden = true
                        DACSetUnit.hidden = true
                        
                        settingSlider.hidden = true
                    }
                    else if (sender == LEDBtn) {
                        LEDSetTitle.hidden = false
                        LEDSlider.hidden = false
                        LEDSetValue.hidden = false
                        LEDSetUnit.hidden = false
                        
                        ADCSetTitle.hidden = true
                        ADCSlider.hidden = true
                        ADCSetValue.hidden = true
                        ADCSetUnit.hidden = true
                        
                        
                        DACSetTitle.hidden = true
                        DACSlider.hidden = true
                        DACSetValue.hidden = true
                        DACSetUnit.hidden = true
                        
                        settingSlider.hidden = true
                    }
                    else if (sender == DACBtn) {
                        DACSetTitle.hidden = false
                        DACSlider.hidden = false
                        DACSetValue.hidden = false
                        DACSetUnit.hidden = false
                        
                        ADCSetTitle.hidden = true
                        ADCSlider.hidden = true
                        ADCSetValue.hidden = true
                        ADCSetUnit.hidden = true
                        
                        
                        LEDSetTitle.hidden = true
                        LEDSlider.hidden = true
                        LEDSetValue.hidden = true
                        LEDSetUnit.hidden = true
                        
                        settingSlider.hidden = true
                    }
                }
            }
            else {
                button.selected = false
            }
        }

    }
    @IBAction func ByP1BtnAct(sender: UIButton) {
        sender.selected = !sender.selected
    }
    @IBAction func ByP2BtnAct(sender: UIButton) {
        sender.selected = !sender.selected
    }
    @IBAction func selectBtnAct(sender: UIButton) {
        if (ADCBtn.selected){
            //Test only
            bleInstance.buf = [0x05, 0x00, 0x00]
            let FAN = UInt8(ADCSlider.value)
            bleInstance.buf[1] = FAN
            bleInstance.transmit()
            let FANmA = (1-(Float(FAN)/255))*100
            //println("Fan: \(FANmA)")
            let FanPercent = String(format: "%0.0f",FANmA)
            ADCValue.text = "\(FanPercent)%"
        } else {
            if (LEDBtn.selected){
                bleInstance.buf = [0x02, 0x00, 0x00]
                let PWM = UInt8(LEDSlider.value)
                bleInstance.buf[1] = PWM
                bleInstance.transmit()
                LEDValue.text = "\(PWM)"
            } else{
                if (DACBtn.selected){
                    bleInstance.buf = [0x03, 0x00, 0x00]
                    let DAC = UInt8(DACSlider.value)
                    //println("\(DAC)")
                    bleInstance.buf[1] = DAC
                    bleInstance.transmit()
                    let DACmW = Float(2.048 * (Float(DAC)/256))
                    //println("\(DACmW)")
                    DACValue.text = "\(DACmW)"
                }
            }
        }
    }
    
    
    @IBAction func settingSldrAct(sender: UISlider) {
    }
    @IBAction func ADCSldrAct(sender: UISlider) {
        ADCSetValue.text = "\(Int(ADCSlider.value))"
    }
    @IBAction func LEDSldrAct(sender: UISlider) {
        LEDSetValue.text = "\(Int(LEDSlider.value))"
    }
    @IBAction func DACSldrAct(sender: UISlider) {
        DACSetValue.text = "\(Int(DACSlider.value))"
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bleInstance.BenchViewDelegate = self
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        configuresettingSlider()
        configureADCSldr()
        configureLEDSlider()
        configureDACSlider()
    }
    
    func configuresettingSlider(){
        let leftTrackImage = UIImage(named: "sliderMaxMin")
        settingSlider.setMinimumTrackImage(leftTrackImage, forState: .Normal)
        
        let rightTrackImage = UIImage(named: "sliderMaxMin")
        settingSlider.setMaximumTrackImage(rightTrackImage, forState: .Normal)
        
        let thumbImage = UIImage(named: "sliderBtn")
        settingSlider.setThumbImage(thumbImage, forState: .Normal)
        
        settingSlider.minimumValue = 0
        settingSlider.maximumValue = 1024
        settingSlider.continuous = true
        settingSlider.value = 0

    }
    
    func configureADCSldr(){
        let leftTrackImage = UIImage(named: "sliderMaxMin")
        ADCSlider.setMinimumTrackImage(leftTrackImage, forState: .Normal)
        
        let rightTrackImage = UIImage(named: "sliderMaxMin")
        ADCSlider.setMaximumTrackImage(rightTrackImage, forState: .Normal)
        
        let thumbImage = UIImage(named: "sliderBtn")
        ADCSlider.setThumbImage(thumbImage, forState: .Normal)
        
        ADCSlider.minimumValue = 0
        ADCSlider.maximumValue = 255
        ADCSlider.continuous = true
        ADCSlider.value = 255
    }
    
    func configureLEDSlider() {
        let leftTrackImage = UIImage(named: "sliderMaxMin")
        LEDSlider.setMinimumTrackImage(leftTrackImage, forState: .Normal)
        
        let rightTrackImage = UIImage(named: "sliderMaxMin")
        LEDSlider.setMaximumTrackImage(rightTrackImage, forState: .Normal)
        
        let thumbImage = UIImage(named: "sliderBtn")
        LEDSlider.setThumbImage(thumbImage, forState: .Normal)
        
        LEDSlider.minimumValue = 0
        LEDSlider.maximumValue = 255
        LEDSlider.continuous = true
        LEDSlider.value = 0
    }
    
    func configureDACSlider() {
        let leftTrackImage = UIImage(named: "sliderMaxMin")
        DACSlider.setMinimumTrackImage(leftTrackImage, forState: .Normal)
        
        let rightTrackImage = UIImage(named: "sliderMaxMin")
        DACSlider.setMaximumTrackImage(rightTrackImage, forState: .Normal)
        
        let thumbImage = UIImage(named: "sliderBtn")
        DACSlider.setThumbImage(thumbImage, forState: .Normal)
        
        DACSlider.minimumValue = 0
        DACSlider.maximumValue = 255
        DACSlider.continuous = true
        DACSlider.value = 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return bleInstance.bleNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "Cell"
        let cell = BBTable.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = bleInstance.bleNames[indexPath.row].name
        return cell
    }
    
    // this function handles the selection of the item... hence connection maybe?
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPeripheral:AnyObject = bleInstance.bleNames[indexPath.row]
        bleInstance.connectSelectedDevice(selectedPeripheral)
        BBTable.hidden = true
        BBTableBgnd.hidden = true
        g10Btn.userInteractionEnabled = true
        g100Btn.userInteractionEnabled = true
        g1kBtn.userInteractionEnabled = true
        ADCBtn.userInteractionEnabled = true
        LEDBtn.userInteractionEnabled = true
        DACBtn.userInteractionEnabled = true
        byPassBtn1.userInteractionEnabled = true
        byPassBtn2.userInteractionEnabled = true
        BLEBtn.userInteractionEnabled = true
        settingSlider.userInteractionEnabled = true
        relayBtn.userInteractionEnabled = true
        selectorBtn.userInteractionEnabled = true
        Ch0Btn.selected = true
        BLEValue.text = "BLE: Found"
    }
    
    func getList(controller: BenchBudEECentral) {
        BBTable.reloadData()
    }
    
    func getTemp(controller:BenchBudEECentral){
        let ch1VoltsCalc = Float((Float(bleInstance.analogCh1)*2.37)/(32768*1*3)) * 40 * 1000
        //println("Ch1: \(ch1VoltsCalc)")
        let tempCalc1:Double = (Double(-5.506) * Double(-5.506))
        //println("T1: \(tempCalc1)")
        let tempCalc2:Double = Double(0.0074) * Double((870.6-(ch1VoltsCalc)))
        //println("T2: \(tempCalc2)")
        let tempCalc3:Double = 2 * Double(-0.00176)
        //println("T3: \(tempCalc3)")
        let tempCalc4:Double = Double(sqrt(tempCalc1 + tempCalc2))
        //println("T4: \(tempCalc4)")
        let tempCalc5:Double = ((5.506 - tempCalc4) / tempCalc3) + 30
        //println("temp: \(tempCalc5)")
        let ch1Temp = String(format: "%0.0f",tempCalc5)
        //println("\(ch1Temp)")
        TempValue.text = "Temp: \(ch1Temp)˚C"
    }
    
    func getCh0(controller: BenchBudEECentral) {
        let ch0VoltsCalc = Float((Float(bleInstance.analogCh0)*2.37)/(32768*1*3)) * 40
        //let ch0Volts = String(format: "%.1f",ch0VoltsCalc)
        //println("Ch0: \(ch0VoltsCalc)")
        settingTitle.text = "Ch0: \(ch0VoltsCalc)"
    }
    
    func disconnect(controller: BenchBudEECentral){
        BLEValue.text = "BLE: Off"
        Ch0Btn.selected = false
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
