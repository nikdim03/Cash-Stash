//
//  TranView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit
import SceneKit

//view controller
//protocol
//ref to presenter

//MARK: - TranView
protocol TranViewProtocol {
    var presenter: TranPresenterProtocol? { get set }
    
    var categories: [String] { get set }
    var localTransactions: [TransactionData] { get set }
    var localTranDict: [IndexPath: Int] { get set }
    var sectionedTransactions: [Section] { get set }
    var searchText: String { get set }
    var fromDate: Date { get set }
    var uptoDate: Date { get set }
    var fromDatePicker: UIDatePicker { get set }
    var uptoDatePicker: UIDatePicker { get set }
    var tableView: UITableView { get set }
    var incomeLabel: UILabel { get set }
    var expenseLabel: UILabel { get set }
    var refreshControl: UIRefreshControl { get set }
    var blurView: UIVisualEffectView { get set }
    var scnView: SCNView { get set }
    var ind: Int { get set }
//    var isRefreshing: Bool { get set }
}

class TranView: UIViewController, TranViewProtocol {
    var presenter: TranPresenterProtocol?

    @UsesAutoLayout
    var tableView = UITableView()
    @UsesAutoLayout
    var fromDatePicker = UIDatePicker()
    @UsesAutoLayout
    var uptoDatePicker = UIDatePicker()
    @UsesAutoLayout
    var incomeLabel = UILabel()
    @UsesAutoLayout
    var expenseLabel = UILabel()
    @UsesAutoLayout
    var dateStackView = UIStackView()
    @UsesAutoLayout
    var balanceStackView = UIStackView()
    @UsesAutoLayout
    var trashButton = UIButton()
    @UsesAutoLayout
    var addStackView = UIStackView()
    @UsesAutoLayout
    var addTransactionButton = UIButton()
    @UsesAutoLayout
    var addCategoryButton = UIButton()
    @UsesAutoLayout
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    @UsesAutoLayout
    var scnView = SCNView()
    
    var fromDate = Date() - 30 * 24 * 60 * 60
    var uptoDate = Date() + 24 * 60 * 60
    let fromLabel = UILabel()
    let uptoLabel = UILabel()
    var refreshControl = UIRefreshControl()
    let searchController = UISearchController()
    var localTransactions = [TransactionData]()
    var localTranDict = [IndexPath: Int]()
    var sectionedTransactions = [Section]()
    var categories = [String]()
    var searchText = ""
    var ind = 0
//    var isRefreshing = false
//    var coord = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.initCategoriesFromDefaults()
        configureTrashButton()
        configureBalanceStackView()
        configureDateStackView()
        configureTableView()
        configureSearchController()
        configureAddStackView()
        showPig() // already on main thread
        presenter?.startRefreshingTransactions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trashButton.isHidden = true
    }
    
    func configureTrashButton() {
        trashButton.isHidden = false
        trashButton.setTitle(" Delete", for: .normal)
        trashButton.setImage(UIImage(named: "trash"), for: .normal)
        trashButton.sizeToFit()
        trashButton.addTarget(self, action: #selector(trashButtonPressed), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: trashButton)
        tabBarController?.navigationItem.rightBarButtonItems = [barButtonItem]
        view.addSubview(trashButton)
    }
    
    func configureBalanceStackView() {
        view.addSubview(balanceStackView)
        balanceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        balanceStackView.heightAnchor.constraint(equalToConstant: 20).activate()
        balanceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).activate()
        balanceStackView.axis = .horizontal
        balanceStackView.alignment = .fill
        balanceStackView.spacing = 40
        balanceStackView.addArrangedSubview(UIImageView(image: UIImage(named: "arrowtriangle.up.fill")))
        balanceStackView.addArrangedSubview(incomeLabel)
        balanceStackView.addArrangedSubview(UIImageView(image: UIImage(named: "arrowtriangle.down.fill")))
        balanceStackView.addArrangedSubview(expenseLabel)
    }
    
    func configureDateStackView() {
        fromLabel.text = "FROM"
        uptoLabel.text = "UPTO"
        fromDatePicker.addTarget(self, action: #selector(fromDatePickerPressed(_:)), for: .valueChanged)
        uptoDatePicker.addTarget(self, action: #selector(uptoDatePickerPressed(_:)), for: .valueChanged)
        fromDatePicker.datePickerMode = .date
        uptoDatePicker.datePickerMode = .date
        fromDatePicker.date = fromDate
        uptoDatePicker.date = uptoDate
        view.addSubview(dateStackView)
        dateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        dateStackView.heightAnchor.constraint(equalToConstant: 40).activate()
        dateStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 10).activate()
        dateStackView.axis = .horizontal
        dateStackView.alignment = .fill
        dateStackView.spacing = 3

        dateStackView.addArrangedSubview(fromLabel)
        dateStackView.addArrangedSubview(fromDatePicker)
        dateStackView.addArrangedSubview(uptoLabel)
        dateStackView.addArrangedSubview(uptoDatePicker)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.rowHeight = 50
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).activate()
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).activate()
        tableView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10).activate()
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).activate()
        refreshControl.addTarget(self, action: #selector(showLoadingAnimation), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func configureSearchController() {
        view.addSubview(searchController.searchBar)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "SEARCH IN TRANSACTIONS"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        var scopeTitles = ["All"]
        var i = 1
        for category in categories {
            if (i == 5) {
                break
            }
            scopeTitles.append(category)
            i += 1
        }
        searchController.searchBar.scopeButtonTitles = scopeTitles
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func configureAddStackView() {
        addTransactionButton.setTitle("NEW TRANSACTION", for: .normal)
//        addTransactionButton.setImage(UIImage(named: "plus.circle"), for: .normal)
        addTransactionButton.heightAnchor.constraint(equalToConstant: 50).activate()
        addTransactionButton.layer.cornerRadius = 15
        addTransactionButton.backgroundColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 0.6)
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonPressed), for: .touchUpInside)
        
        addCategoryButton.setTitle("NEW CATEGORY", for: .normal)
//        addCategoryButton.setImage(UIImage(named: "plus.circle"), for: .normal)
        addCategoryButton.heightAnchor.constraint(equalToConstant: 50).activate()
        addCategoryButton.layer.cornerRadius = 15
        addCategoryButton.backgroundColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 0.6)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)

        addStackView.distribution = .fillEqually
        addStackView.spacing = 10
        addStackView.addArrangedSubview(addTransactionButton)
        addStackView.addArrangedSubview(addCategoryButton)
        view.addSubview(addStackView)
        addStackView.bottomAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).activate()
        addStackView.leadingAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).activate()
        addStackView.trailingAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).activate()
//        addStackView.centerXAnchor.constraint(equalTo: super.view.centerXAnchor).activate()
//        addStackView.centerYAnchor.constraint(equalTo: super.view.centerYAnchor).activate()
    }

    @objc func trashButtonPressed(_ sender: UIBarButtonItem) {
        if trashButton.titleLabel?.text == " Delete" {
            trashButton.setTitle(" Done", for: .normal)
            trashButton.setImage(UIImage(named: "checkmark.diamond"), for: .normal)
            tableView.setEditing(true, animated: true)
        } else {
            trashButton.setTitle(" Delete", for: .normal)
            trashButton.setImage(UIImage(named: "trash"), for: .normal)
            tableView.setEditing(false, animated: true)
        }
    }
    
    @objc func fromDatePickerPressed(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.selectDate()
                self.fromDate = self.fromDatePicker.date
                self.uptoDatePicker.minimumDate = self.fromDatePicker.date
            }
            self.showPig()
        }
        presenter?.startRefreshingTransactions()
    }
    
    @objc func uptoDatePickerPressed(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.selectDate()
                self.uptoDate = self.uptoDatePicker.date
            }
            self.showPig()
        }
        presenter?.startRefreshingTransactions()
    }

    func selectDate() {
//        refreshTransactionsList()
        sectionedTransactions.removeAll { section in
            section.date < fromDatePicker.date || section.date > uptoDatePicker.date
        }
        presenter?.updateBalance()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    @objc func addTransactionButtonPressed() {
        presenter?.showAddTranVC()
    }
    
    @objc func addCategoryButtonPressed() {
        let alert = presenter!.createAlert()
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    func showPig() {
        view.addSubview(blurView)
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        blurView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()

        view.addSubview(scnView)
        scnView.heightAnchor.constraint(equalToConstant: 150).activate()
        scnView.widthAnchor.constraint(equalToConstant: 150).activate()
        scnView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).activate()
        scnView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        let scene = SCNScene(named: "art.scnassets/piggy_bank.obj")!
        let pigNode = scene.rootNode.childNodes.first!
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 1.0, green: 145.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.black
        pigNode.geometry!.materials = [material, material2]
        
        let rotateAction = SCNAction.rotate(by: CGFloat(2 * Double.pi), around: .init(0, 1, 0), duration: 1)
//        let rotateAction = SCNAction.rotateTo(x: CGFloat(2 * Double.pi), y: 0, z: 0, duration: 1)
//        let pauseAction = SCNAction.wait(duration: 0.4)
//        pigNode.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)

//        let actionSequence = SCNAction.sequence([rotateAction, pauseAction])
        pigNode.runAction(SCNAction.repeatForever(rotateAction))
//        pigNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = .clear
        scnView.scene = scene
    }
    
    
    @objc func showLoadingAnimation() {
        DispatchQueue.main.async {
            self.showPig()
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//                self.hidePig()
//            }
        }
        presenter?.startRefreshingTransactions()

//        presenter?.startRefreshingTransactions()
    }
}


//MARK: - TransactionCell
class TransactionCell: UITableViewCell {
    @UsesAutoLayout
    var amountLabel = UILabel()
    @UsesAutoLayout
    var titleLabel = UILabel()
    @UsesAutoLayout
    var categoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureTransactionCell(with model: TranCellEntity) {
        var cur = ""
        if model.currency == "руб." || model.currency == "₽" {
            cur = "₽"
        }
        if model.isIncome {
            amountLabel.text = "+ \(cur)\(model.amount.removeZerosFromEnd())"
            amountLabel.textColor = .green
        } else {
            amountLabel.text = "- \(cur)\(model.amount.removeZerosFromEnd())"
            amountLabel.textColor = .red
        }
        amountLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.text = model.payee.isEmpty ? "Title missing" : model.payee
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 0.33, green: 0.00, blue: 0.92, alpha: 1)
        categoryLabel.text = model.category
        configureTitleLabel()
        configureAmountLabel()
        configureCategoryLabel()
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3).activate()
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).activate()
    }

    func configureAmountLabel() {
        contentView.addSubview(amountLabel)
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        amountLabel.widthAnchor.constraint(equalToConstant: 100).activate()
        amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).activate()
    }
    
    func configureCategoryLabel() {
        if (categoryLabel.text != "") {
            contentView.addSubview(categoryLabel)
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).activate()
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).activate()
        }
    }
}


//MARK: - TranView Extensions
extension TranView: UITableViewDelegate, UITableViewDataSource {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if isRefreshing { return }
//        isRefreshing = true
//        coord = scrollView.contentOffset.y
//        print(scrollView.contentOffset.y)
//        if scrollView.contentOffset.y < 0 {
//            showLoadingAnimation()
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print(#function)
//        isRefreshing = false
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionedTransactions[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else { return UITableViewCell() }
        let transaction = sectionedTransactions[indexPath.section].items[indexPath.row]
        cell.configureTransactionCell(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter?.chooseTitleForHeader(with: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToDetails(with: sectionedTransactions[indexPath.section].items[indexPath.row], and: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if sectionedTransactions[indexPath.section].items[indexPath.row].account == "Not specified" {
            if ind < localTransactions.count && localTranDict.first(where: { $0.value == ind })?.key ?? indexPath <= indexPath {
                localTranDict.updateValue(ind, forKey: indexPath)
                ind += 1
//                print(ind, [indexPath.section, indexPath.row])
            }
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.removeTransaction(at: indexPath)
        }
    }
}

extension TranView: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        DispatchQueue.main.async {
            self.showPig()
        }
        searchText = searchController.searchBar.scopeButtonTitles![selectedScope]
        if searchText == "All" {
            searchController.searchBar.text = ""
            presenter?.startRefreshingTransactions()
        } else {
            searchController.searchBar.text = searchText
        }
        presenter?.considerFilter(with: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.sizeToFit()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.sizeToFit()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText = text
        presenter?.considerFilter(with: false)
    }
}
