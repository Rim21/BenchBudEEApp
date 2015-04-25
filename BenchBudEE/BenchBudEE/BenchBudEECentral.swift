//
//  BenchBudEECentral.swift
//  BenchBudEE
//
//  Created by Rim21 on 1/01/2015.
//  Copyright (c) 2015 Nathan Rima. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol centralData {
    func getList(controller: BenchBudEECentral) -> (Void)
    func getTemp(controller: BenchBudEECentral) -> (Void)
    func getCh0(controller: BenchBudEECentral) -> (Void)
    func disconnect(controller: BenchBudEECentral) -> (Void)
}

class BenchBudEECentral: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var analogCh1:UInt16 = 0
    var analogCh0:UInt16 = 0

    
    // Needed Services
    
    var bleNames:NSMutableArray = NSMutableArray()
    
    //sets up the onOff button to reflect that you are turning on the BLE functions
    var readyBLE = false
    
    //used to check if the Devices BLE has been powered on
    var bluetoothReady = false
    
    var BBcentral: CBCentralManager!
    var BBperipheral: CBPeripheral!
    var txCharacteristic: CBCharacteristic?
    var rxCharacteristic: CBCharacteristic?
    var BenchViewDelegate: BenchBudEEViewController? = nil
    var buf:[UInt8] = [0x00]


    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        
        // Validate peripheral information
        if ((peripheral == nil) || (peripheral.name == nil) || (peripheral.name == "")) {
            return
        }
        
        BBperipheral = peripheral
        
        bleNames.addObject(peripheral)
        println("Available devices: \(bleNames)")
        
        // Reload data on the ViewController's tableview
        if (BenchViewDelegate != nil) {
            BenchViewDelegate!.getList(self)
        }
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect to Peripheral \(error.description)")
        cleanup()
    }
    
    func connectSelectedDevice(peripheral: AnyObject) {
        BBperipheral = peripheral as! CBPeripheral
        BBcentral.connectPeripheral(BBperipheral, options: nil)
    }
    
    func transmit() {
        if let characteristic = txCharacteristic {
            let data = NSData(bytes: buf, length: 3)
            BBperipheral?.writeValue(data, forCharacteristic: characteristic, type: .WithoutResponse)
        }

    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        BBcentral?.stopScan()
        println("Scan Stopped")
        peripheral.delegate = self
        println("Connected to Peripheral: \(peripheral.name)\n")
        peripheral.discoverServices(BB_ServiceUUID)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error != nil {
            println("\(error.description)")
            cleanup()
        } else {
            println("Found Service \n")
            for service in peripheral.services as! [CBService]! {
                println("\(service.description)\n")
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error != nil {
            println("\(error.description)")
            cleanup()
            return
        } else {
            for characteristic in service.characteristics as! [CBCharacteristic] {
                // And check if it's the right one
                switch characteristic.UUID.UUIDString {
                case BBSERVICE_UUID:
                    println("Service Characteristic\n")
                    //displayInfoOutput("\n Hardware \n")
                case BB_READ_CHARACTERISTIC_UUID:
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                    //displayInfoOutput("\n Read \n")
                    println("Read\n")
                    rxCharacteristic = characteristic
                case BB_WRITE_CHARACTERISTIC_UUID:
                    //displayInfoOutput("\n Write \n")
                    println("Write\n")
                    txCharacteristic = characteristic
                default:
                    println("Switch default")
                    //displayInfoOutput("\n")
                }

            }
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if let error = error {
            println("Error discovering services: \(error.localizedDescription)")
            return
        } else {
            if let characteristic = rxCharacteristic {
                getInfo(characteristic)
            }
        }
    }
    
    func getInfo(characteristic:CBCharacteristic) {
        var data = characteristic.value
        var values = [UInt8](count:data.length, repeatedValue:0)
        data.getBytes(&values, length: data.length)
        if values[0] == 0x0B {
            analogCh1 = UInt16(values[2]) | UInt16(values[1]) << 8
            if (BenchViewDelegate != nil) {
                BenchViewDelegate!.getTemp(self)
            }
        } else {
            if values[0] == 0x0D{
            analogCh0 = UInt16(values[2]) | UInt16(values[1]) << 8
            if (BenchViewDelegate != nil) {
                BenchViewDelegate!.getCh0(self)
                }
            }
        }
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Peripheral disconnected")
        //BBperipheral = nil
        if (peripheral == nil) {
            return
        }
        
        // See if it was our peripheral that disconnected
        if (peripheral == BBperipheral) {
            if (BenchViewDelegate != nil) {
                BenchViewDelegate!.disconnect(self)
            }
            clearDevices()
        }
    }
    
    func disconnectPeripheral(peripheral: CBPeripheral?) {
        //not sure what this function does, aside from its name of course as it isn't called
        if peripheral == nil {
            return
        }
        BBcentral?.cancelPeripheralConnection(peripheral)
    }

        
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if (central.state != CBCentralManagerState.PoweredOn){
            bluetoothReady = false
        } else {
            bluetoothReady = true
            println("Device is powered on \n")
            scan()
        }
    }
    
    func clearDevices() {
        println("Clear Devices")
        BBcentral = nil
        BBperipheral = nil
    }

    
    func powerOn() {
        BBcentral = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    func scan() {
        BBcentral.scanForPeripheralsWithServices(BB_ServiceUUID, options: nil)
        println("Scanning started")
    }
    
    func cleanup() {
        println("Clean-up")
        buf = [0x04, 0x00, 0x00]
        transmit()
        if ([bleNames.count] == 0) {
            //endconnect()
        } else {
        bleNames.removeAllObjects()
        // Reload data on the ViewController's tableview
        if (BenchViewDelegate != nil) {
            BenchViewDelegate!.getList(self)
            }
        }
        endconnect()
    }
    
    
    func endconnect() {
        println("End connect??")
        if BBperipheral != nil {
            BBperipheral = nil
        }
    }


}