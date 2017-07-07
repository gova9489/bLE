//
//  ViewController.swift
//  bLE
//
//  Created by Govardhan on 6/25/17.
//  Copyright © 2017 Govardhan. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var manager: CBCentralManager!                 // Services Manager
    var peripherals = Array<CBPeripheral>()               // Peripheral manager
    var consoleMsg = ""               // displays bluetooth status
    
//    
//    let BLE_NAME = "WiMedics"       // define device name
//    let BLE_UUID = CBUUID.init(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")      // Initiating UUID for device
//    let BLE_SERVICE_UUID = CBUUID.init(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")  // Initiating service UUID
//    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        

    }
    
    
    @IBAction func scanForDevices(_ sender: UIButton) {
        textLabel.text? = consoleMsg
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        cell.detailTextLabel?.text = String(describing: peripheral.identifier)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
}

// CBCentralManagerDelegate Extension
extension ViewController: CBCentralManagerDelegate {

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripherals.contains(peripheral)
        {
            tableView.reloadData()
        } else
        {
        peripherals.append(peripheral)
        tableView.reloadData()
        print("Peripheral: \(peripheral)")
        }
        
        //        let device = (advertisementData as NSDictionary)
        //            .object(forKey: CBAdvertisementDataLocalNameKey)
        //            as? NSString
        //
        //        if device?.contains(BLE_NAME) == true {
        //            self.manager.stopScan()
        //
        //            self.blePeripheral = peripheral
        //            self.blePeripheral.delegate = self
        //
        //            manager.connect(peripheral, options: nil)
        //        }
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch (central.state) {
        case.poweredOff:
            consoleMsg = "Please turn on Bluetooth"
        case.poweredOn:
            self.manager?.scanForPeripherals(withServices: nil, options: nil)
            consoleMsg = "BLE is Powered on and Scanning"
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
        
//        central.scanForPeripherals(withServices: nil, options: nil)
//        print("Discovered peripheral is \(String(describing: peripheral.name))")
//        self.peripherals = [peripheral]
//        manager.stopScan()
    }
    
}

// PeriphralDelegate Extension
extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
       
//        for service in peripheral.services! {
//            let thisService = service as CBService
//            
//            if service.uuid == BLE_SERVICE_UUID {
//                peripheral.discoverCharacteristics(
//                    nil,
//                    for: thisService
//                )
//            }
//        }
//        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
//        for characteristic in service.characteristics! {
//            let thisCharacteristic = characteristic as CBCharacteristic
//            
//            if thisCharacteristic.uuid == BLE_UUID {
//            }
//        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
     
        
    }
    
    
}



