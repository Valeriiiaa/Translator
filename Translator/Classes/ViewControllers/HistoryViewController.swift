//
//  HistoryViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit
import SwiftEntryKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var historyLabel: UILabel!
    var historyModels: [BaseHistoryModel] = [HistoryEmptyModel(id: "1")]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellManager.getCell(by: "HistoryEmptyCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "HistoryEmptyCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "HistoryFullCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "HistoryFullCell"))
    }
    

    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
//        showPopup()
    }
   
//    private func showPopup() {
//        let view = ClearChatView.fromNib()
//        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
//        var attributes = EKAttributes.centerFloat
//        attributes.displayDuration = .infinity
//        attributes.screenInteraction = .dismiss
//        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
//        SwiftEntryKit.display(entry: view, using: attributes)
//    }

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
        return cell
    }
   
    
}
