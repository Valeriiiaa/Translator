//
//  SelectionCountryViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class SelectionCountryViewController: UIViewController {
    
    @IBOutlet weak var tableViewSection: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectionModels = [SectionModel(title: "Recently used", countryModels: [SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Hungarian", flagPicture: "hungarian", isSelected: false), SelectionCountryModel(nameCountry: "Icelandic", flagPicture: "hindi", isSelected: false)]), SectionModel(title: "All languages", countryModels: [SelectionCountryModel(nameCountry: "Indonesian", flagPicture: "hindi", isSelected: true), SelectionCountryModel(nameCountry: "Italian", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Spain", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Turkey", flagPicture: "hindi", isSelected: false)])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.cornerRadius = 15
        searchBar.layer.masksToBounds = true
        searchBar.text = "Search your language..."
        searchBar.searchTextField.font = UIFont(name: "Fixel-Medium", size: 14)
        searchBar.searchTextField.textColor = UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1)
        tableViewSection.dataSource = self
        tableViewSection.delegate = self
        tableViewSection.register(UINib(nibName: "SectionCountryCell" , bundle: nil), forCellReuseIdentifier: "SectionCountryCell")
        tableViewSection.register(UINib(nibName: "SelectionCountryHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SelectionCountryHeaderView")
    }
    
    
    @IBAction func backbuttonDidTap(_ sender: Any) {
    }
    
    
}

extension SelectionCountryViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectionModels[section].countryModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        selectionModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemSection = selectionModels[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectionCountryHeaderView")
        (header as? SelectionCountryHeaderView)?.configure(name: itemSection.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != 0 else { return .leastNormalMagnitude }
            return 50
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = selectionModels[indexPath.section].countryModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCountryCell", for: indexPath)
        (cell as? SectionCountryCell)?.configure(flagPicture: model.flagPicture, labelCountry: model.nameCountry)
        return cell
    }
}
   
    
    

