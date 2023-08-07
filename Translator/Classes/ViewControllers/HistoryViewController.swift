//
//  HistoryViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit
import SwiftEntryKit
import Switches
import IHProgressHUD

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var backgroundViewEraser: UIView!
    @IBOutlet weak var adsSwitcher: YapSwitch!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyLabel: UILabel!
    
    public var storage: UserDefaultsStorage!
    
    var historyModels: [BaseHistoryModel] = [HistoryEmptyModel(id: "1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellManager.getCell(by: "HistoryEmptyCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "HistoryEmptyCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "HistoryFullCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "HistoryFullCell"))
        
        let historyModels: [HistoryFullModel] = storage.get(key: .history, defaultValue: [])
        if historyModels.isEmpty == false {
            self.historyModels = historyModels
            eraserButton.isHidden = false
            backgroundViewEraser.isHidden = false
        }
        tableView.reloadData()
    }
    
    func checkHistoryModels() {
        if historyModels.isEmpty == true {
            self.historyModels = [HistoryEmptyModel(id: "1")]
            eraserButton.isHidden = true
            backgroundViewEraser.isHidden = true
            tableView.reloadData()
        }
    }
    
    @IBAction func valueDidTap(_ sender: Any) {
        if adsSwitcher.isOn == true {
            pushPremiumScreen()
        } else {
            
        }
    }
    
    func pushPremiumScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(identifier: "PremiumViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func eraserButtonDidTap(_ sender: Any) {
        showPopup()
    }
   
    private func showPopup() {
        let view = ClearHistoryView.fromNib()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        attributes.entryInteraction = .forward
        SwiftEntryKit.display(entry: view, using: attributes)
        view.deletedAllCellsTapped = {[weak self] in
            self?.historyModels.removeAll()
            self?.tableView.reloadData()
            self?.checkHistoryModels()
            self?.storage.clear(key: .history)
            SwiftEntryKit.dismiss(with: {
                IHProgressHUD.showSuccesswithStatus("History was cleared")
                IHProgressHUD.dismissWithDelay(0.5)
            })
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = historyModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model is HistoryEmptyModel ? CellManager.getCell(by: "HistoryEmptyCell") : CellManager.getCell(by: "HistoryFullCell"), for: indexPath)
        if let historyFullModel = model as? HistoryFullModel {
            (cell as? HistoryFullTableViewCell)?.configure(originalText: historyFullModel.originalText , translatedText: historyFullModel.translatedText, flagFirst: historyFullModel.firstFlag, flagSecond: historyFullModel.secondFlag, firstLanguage: historyFullModel.firstLanguageLabel, secondLanguage: historyFullModel.secondLanguageLabel)
            (cell as? HistoryFullTableViewCell)?.deleteButtonTapped = {[weak self] in
                UserDefaultsStorage.shared.remove(key: .history, value: historyFullModel)
                self?.historyModels.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.checkHistoryModels()
                IHProgressHUD.showSuccesswithStatus("Deleted successfully")
                IHProgressHUD.dismissWithDelay(0.4)
            }
        }
        return cell
    }
    
    
}
