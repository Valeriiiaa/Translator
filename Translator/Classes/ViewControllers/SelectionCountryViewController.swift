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
    
    var allItems = [SectionModel(title: "Recently used", countryModels: [SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Hungarian", flagPicture: "hungarian", isSelected: false), SelectionCountryModel(nameCountry: "Icelandic", flagPicture: "hindi", isSelected: false)]), SectionModel(title: "All languages", countryModels: [SelectionCountryModel(nameCountry: "Indonesian", flagPicture: "hindi", isSelected: true), SelectionCountryModel(nameCountry: "Italian", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Spain", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Turkey", flagPicture: "hindi", isSelected: false)])] {
        didSet {
            selectionModels = allItems
        }
    }
    
    private var selectionModels = [SectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            searchBar.layer.cornerRadius = 15
            
        default:
            searchBar.layer.cornerRadius = 25
        }
        
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.font = UIFont(name: "Fixel-Medium", size: 14)
        selectionModels = allItems
        tableViewSection.dataSource = self
        tableViewSection.delegate = self
        tableViewSection.register(UINib(nibName: CellManager.getCell(by: "SectionCountryCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "SectionCountryCell"))
        tableViewSection.register(UINib(nibName: HeaderManager.getHeader(by: "SelectionCountryHeaderView"), bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderManager.getHeader(by: "SelectionCountryHeaderView"))
        searchBar.delegate = self
        searchBar.placeholder = "Search your language..."
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1), .font: UIFont.systemFont(ofSize: 15)])

        default:  searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1), .font: UIFont.systemFont(ofSize: 25)])
        }
    
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                view.addGestureRecognizer(tapGesture)
        
        view.isUserInteractionEnabled = true
    }
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
           if let searchBarFrame = searchBar?.frame, !searchBarFrame.contains(gestureRecognizer.location(in: view)) {
               searchBar?.resignFirstResponder()
           }
       }
    
    @IBAction func backbuttonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderManager.getHeader(by: "SelectionCountryHeaderView"))
        (header as? SelectionCountryHeaderView)?.configure(name: itemSection.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != 0 else { return .leastNormalMagnitude }
            return 50
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = selectionModels[indexPath.section].countryModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "SectionCountryCell"), for: indexPath)
        (cell as? SectionCountryCell)?.configure(flagPicture: model.flagPicture, labelCountry: model.nameCountry)
        return cell
    }
}
   
    
extension SelectionCountryViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        defer { tableViewSection.reloadData() }
        guard !searchText.isEmpty else {
            selectionModels = allItems
            return
        }
        let languages = allItems[1].countryModels
        let filtredLanguages = languages.filter({ item in
            item.nameCountry.hasPrefix(searchText)
        })
        selectionModels = [SectionModel(title: "", countryModels: filtredLanguages)]
        tableViewSection.reloadData()
    }
    
    
}
