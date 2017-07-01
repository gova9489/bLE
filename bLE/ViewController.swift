//
//  ViewController.swift
//  bLE
//
//  Created by Govardhan on 6/25/17.
//  Copyright © 2017 Govardhan. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deviceInfo: UILabel!         // for bluetooth device information
    @IBOutlet weak var message: UILabel!            // message to be appear on screen i.e dynamic data

    var manager: CBCentralManager!                 // Services Manager
    var blePeripheral: CBPeripheral!               // Peripheral manager
    
    let BLE_NAME = "WiMedics"       // define device name
    let BLE_UUID = CBUUID.init(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")      // Initiating UUID for device
    let BLE_SERVICE_UUID = CBUUID.init(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")  // Initiating service UUID
    
    
    
    var consoleMsg = ""               // displays bluetooth status
    var dataFromBLE = ""             // message from bluetooth device
    var deviceDetails = ""           // device data such as name and unique id etc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CBCentralManager(delegate: self, queue: nil)
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
         peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Peripheral: \(peripheral)")
        
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        
        if device?.contains(BLE_NAME) == true {
            self.manager.stopScan()
            
            self.blePeripheral = peripheral
            self.blePeripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch (central.state) {
        case.poweredOff:
            consoleMsg = "Please turn on Bluetooth"
        case.poweredOn:
            consoleMsg = "BLE is Powered on"
        case.resetting:
            consoleMsg = "BLE is Resetting"
        case.unauthorized:
            consoleMsg = "BLE is Unauthorized"
        case.unknown:
            consoleMsg = "BLE is Unknown"
        case.unsupported:
            consoleMsg = "BLE is Not supported"
            
        }
        print("\(consoleMsg)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        central.scanForPeripherals(withServices: nil, options: nil)
        print("Discovered peripheral is \(String(describing: peripheral.name))")
        self.blePeripheral = peripheral
        manager.stopScan()
    }
    
    @IBAction func scanForDevices(_ sender: UIButton) {
        textLabel.text? = consoleMsg
    
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
       
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == BLE_SERVICE_UUID {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == BLE_UUID {
            }
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
     
        
    }
    
    
    


}
