//
//  TranView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/3/23.
//

import UIKit

//view controller
//protocol
//ref to presenter

//MARK: - TransactionsVC
protocol TranViewProtocol {
    var presenter: TranPresenterProtocol? { get set }
    
    var categories: [String] { get set }
    var localTransactions: [TransactionData] { get set }
    var sectionedTransactions: [Section] { get set }
    var searchText: String { get set }
    var fromDate: Date { get set }
    var uptoDate: Date { get set }
    var fromDatePicker: UIDatePicker { get set }
    var uptoDatePicker: UIDatePicker { get set }
    var tableView: UITableView { get set }
    var incomeLabel: UILabel { get set }
    var expenceLabel: UILabel { get set }
    var stateManager: StateManager? { get set }
    var refreshControl: UIRefreshControl { get set }
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
    var expenceLabel = UILabel()
    @UsesAutoLayout
    var dateStackView = UIStackView()
    @UsesAutoLayout
    var balanceStackView = UIStackView()
    @UsesAutoLayout
    var editButton = UIButton()
    @UsesAutoLayout
    var addStackView = UIStackView()
    @UsesAutoLayout
    var addTransactionButton = UIButton()
    @UsesAutoLayout
    var addCategoryButton = UIButton()
    
    var fromDate = Date() - 30 * 24 * 60 * 60
    var uptoDate = Date() + 24 * 60 * 60
    let fromLabel = UILabel()
    let uptoLabel = UILabel()
    var refreshControl = UIRefreshControl()
    let searchController = UISearchController()
    var localTransactions = [TransactionData]()
    var sectionedTransactions = [Section]()
    var categories = [String]()
    var stateManager: StateManager?
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.initCategoriesFromDefaults()
        
        configureEditButton()
        configureBalanceStackView()
        configureDateStackView()
        configureTableView()
        configureSearchController()
        configureAddStackView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard stateManager?.state != .loaded else { return }
        presenter?.startRefreshingTransactions()
    }
    
    func configureEditButton() {
        editButton.setTitle("Edit", for: .normal)
        editButton.sizeToFit()
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: editButton)
        tabBarController?.navigationItem.rightBarButtonItems = [barButtonItem]
        view.addSubview(editButton)
    }
    
    func configureBalanceStackView() {
        view.addSubview(balanceStackView)
        balanceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        balanceStackView.heightAnchor.constraint(equalToConstant: 20).activate()
        balanceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        balanceStackView.axis = .horizontal
        balanceStackView.alignment = .fill
        balanceStackView.spacing = 40
        balanceStackView.addArrangedSubview(incomeLabel)
        balanceStackView.addArrangedSubview(expenceLabel)
    }
    
    func configureDateStackView() {
        fromLabel.text = "FROM"
        uptoLabel.text = "UPTO"
        fromDatePicker.addTarget(self, action: #selector(fromDatePickerPressed(_:)), for: .valueChanged)
        fromDatePicker.addTarget(self, action: #selector(uptoDatePickerPressed(_:)), for: .valueChanged)
        fromDatePicker.datePickerMode = .date
        uptoDatePicker.datePickerMode = .date
        fromDatePicker.date = fromDate
        uptoDatePicker.date = uptoDate
        view.addSubview(dateStackView)
        dateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        dateStackView.heightAnchor.constraint(equalToConstant: 40).activate()
        dateStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 0).activate()
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
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.heightAnchor.constraint(equalToConstant: 160).activate()
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).activate()
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).activate()
        tableView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10).activate()
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).activate()
        refreshControl.addTarget(self, action: #selector(userSwipedDown), for: .valueChanged)
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

//        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchController.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).activate()
//        searchController.searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).activate()
//        searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
//        searchController.searchBar.heightAnchor.constraint(equalToConstant: 40).activate()
//        searchController.searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).activate()
    }
    
    func configureAddStackView() {
        addTransactionButton.setTitle("NEW TRANSACTION", for: .normal)
        addTransactionButton.setImage(UIImage(named: "plus.circle"), for: .normal)
        addTransactionButton.heightAnchor.constraint(equalToConstant: 50).activate()
        addTransactionButton.layer.cornerRadius = 15
        addTransactionButton.backgroundColor = .green.withAlphaComponent(0.6)
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonPressed), for: .touchUpInside)
        
        addCategoryButton.setTitle("NEW CATEGORY", for: .normal)
        addCategoryButton.setImage(UIImage(named: "plus.circle"), for: .normal)
        addCategoryButton.heightAnchor.constraint(equalToConstant: 50).activate()
        addCategoryButton.layer.cornerRadius = 15
        addCategoryButton.backgroundColor = .green.withAlphaComponent(0.6)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)

        addStackView.addArrangedSubview(addTransactionButton)
        addStackView.addArrangedSubview(addCategoryButton)
        view.addSubview(addStackView)
        addStackView.bottomAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).activate()
        addStackView.centerXAnchor.constraint(equalTo: super.view.centerXAnchor).activate()
//        addStackView.centerYAnchor.constraint(equalTo: super.view.centerYAnchor).activate()
    }

    @objc func editButtonPressed(_ sender: UIBarButtonItem) {
        if editButton.titleLabel?.text == "Edit" {
            editButton.setTitle("Done", for: .normal)
            tableView.setEditing(true, animated: true)
        } else {
            editButton.setTitle("Edit", for: .normal)
            tableView.setEditing(false, animated: true)
        }
    }
    
    @objc func fromDatePickerPressed(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.uptoDatePicker.minimumDate = self.fromDatePicker.date
            self.fromDate = self.fromDatePicker.date
        }
        presenter?.startRefreshingTransactions()
    }
    
    private func selectDate() {
//        refreshTransactionsList()
        sectionedTransactions.removeAll { section in
            section.date < fromDatePicker.date || section.date > uptoDatePicker.date
        }
        tableView.reloadData()
        presenter?.updateBalance()
    }
    
    @objc func uptoDatePickerPressed(_ sender: UIDatePicker) {
        self.dismiss(animated: true) {
            self.selectDate()
            self.uptoDate = self.uptoDatePicker.date
        }
        presenter?.startRefreshingTransactions()
    }
    
    @objc func addTransactionButtonPressed() {
        presenter?.showAddTranVC()
    }
    
    @objc func addCategoryButtonPressed() {
        let alert = presenter!.createAlert()
        present(alert, animated: true, completion: nil)
    }
    
    @objc func userSwipedDown() {
        presenter?.startRefreshingTransactions()
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
        
    func configureTransactionCell(with model: TransactionCellModel) {
        if model.isIncome {
            amountLabel.text = "+ \(model.amount) \(model.currency)"
            amountLabel.textColor = .green
        } else {
            amountLabel.text = "- \(model.amount) \(model.currency)"
            amountLabel.textColor = .red
        }
        titleLabel.text = model.payee.isEmpty ? "No content" : model.payee
        categoryLabel.text = model.category
        configureTitleLabel()
        configureAmountLabel()
        configureCategoryLabel()
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor).activate()
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
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).activate()
        }
    }
}


//MARK: - TransactionsVC Extensions
extension TranView: UITableViewDelegate, UITableViewDataSource {
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
        //        performSegue(withIdentifier: "ShowTransactionDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        guard let destinationVC = segue.destination as? TransactionDetailViewController else { return }
        //        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        //
        //        destinationVC.transactionCellModel = sectionedTransactions[indexPath.section].items[indexPath.row]
        //    }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if sectionedTransactions[indexPath.section].items[indexPath.row].account == "Not specified" {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.removeTransaction(at: indexPath.row)
        }
//        if editingStyle == .delete {
//            if let transaction = localTransactions?[indexPath.row] {
//                do {
//                    try realm.write {
//                        realm.delete(transaction)
//                    }
//                } catch {
//                    print("Error deleting entry")
//                }
//                refreshTransactionsList()
//            }
//        }
    }
}

extension TranView: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //
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
        presenter?.considerFilter()
    }
}
