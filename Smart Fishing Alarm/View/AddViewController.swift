//
//  AddViewController.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 11. 30..
//

import UIKit
import RxSwift
import RxCocoa

class AddViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }

    func setupBindings() {
        viewModel
            .availableAlarmDevicesSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "deviceCell")) { (row, alarmDevice, cell) in
                cell.textLabel?.text = alarmDevice.name
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AlarmDevice.self)
            .subscribe { [weak self] tappedAlarmDevice in
                self?.viewModel.connectTo(alarmDevice: tappedAlarmDevice)
            }.disposed(by: disposeBag)
    }    
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        viewModel.startScanning()
        sender.titleLabel?.text = "Scanning..."
        sender.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) {_ in
            sender.isEnabled = true
        }
    }
}
