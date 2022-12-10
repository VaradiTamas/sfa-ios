//
//  ViewController.swift
//  Bluetooth
//
//  Created by Morvai Ákos on 2022. 11. 22..
//

import CoreBluetooth
import RxCocoa
import RxSwift
import UIKit
import CoreLocation
import CoreMotion

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    var scanning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Smart Fishing Alram"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped))
        
        setupBindings()
    }
    
    @objc func onAddButtonTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addViewController") as? AddViewController else {
            fatalError("Viewcontroller not found with ID: addViewController")
        }
        present(vc, animated: true)
    }

    func setupBindings() {
        viewModel
            .connectedAlarmDevicesSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "DeviceCell")) { (row, alarmDevice, cell) in
                cell.textLabel?.text = alarmDevice.name
            }.disposed(by: disposeBag)
    }
}
