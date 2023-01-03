////
////  TransactionsVC.swift
////  Cash Stash
////
////  Created by Dmitriy on 10/27/22.
////
//
//import UIKit
//import CoreData
//
//class TransactionsVC: UIViewController {
//    @UsesAutoLayout
//    var tableView = UITableView()
//    @UsesAutoLayout
//    var fromDatePicker = UIDatePicker()
//    @UsesAutoLayout
//    var uptoDatePicker = UIDatePicker()
//    @UsesAutoLayout
//    var incomeLabel = UILabel()
//    @UsesAutoLayout
//    var expenceLabel = UILabel()
//    @UsesAutoLayout
//    var dateStackView = UIStackView()
//    @UsesAutoLayout
//    var balanceStackView = UIStackView()
//    @UsesAutoLayout
//    var editButton = UIButton()
//    @UsesAutoLayout
//    var addStackView = UIStackView()
//    @UsesAutoLayout
//    var addTransactionButton = UIButton()
//    @UsesAutoLayout
//    var addCategoryButton = UIButton()
//
//    var fromDate = Date() - 30 * 24 * 60 * 60
//    var uptoDate = Date() + 24 * 60 * 60
//
//    let addTransactionVC = AddTransactionVC()
//    let fromLabel = UILabel()
//    let uptoLabel = UILabel()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    struct Section {
//        let date: Date
//        let items: [TransactionCellModel]
//    }
//    var refreshControl = UIRefreshControl()
//    var searchController = UISearchController()
//    var stateManager: StateManager?
//    var localTransactions = [TransactionData]()
//    var sectionedTransactions = [Section]()
//    let defaults = UserDefaults.standard
//    var categories = [String]()
//    var searchText = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//////        categories.removeAll { $0 == "" }
//////        defaults.set(categories, forKey: "Categories")
////
//////        print(filePath)
//////        localTransactions = [TransactionData(context: context)]
////        categories = defaults.array(forKey: "Categories") as? [String] ?? ["Groceries", "Eating Out", "Bills & Charges"]
////        configureEditButton()
////        configureBalanceStackView()
////        configureDateStackView()
////        configureTableView()
////        configureSearchController()
////        configureAddStackView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        guard stateManager?.state != .loaded else { return }
////        DispatchQueue.main.async {
////            self.refreshTransactionsList()
////        }
//    }
//
////    func configureAddStackView() {
////        addTransactionButton.setTitle("NEW TRANSACTION", for: .normal)
////        addTransactionButton.setImage(UIImage(named: "plus.circle"), for: .normal)
////        addTransactionButton.heightAnchor.constraint(equalToConstant: 50).activate()
////        addTransactionButton.layer.cornerRadius = 15
////        addTransactionButton.backgroundColor = .green.withAlphaComponent(0.6)
////        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonPressed), for: .touchUpInside)
////
////        addCategoryButton.setTitle("NEW CATEGORY", for: .normal)
////        addCategoryButton.setImage(UIImage(named: "plus.circle"), for: .normal)
////        addCategoryButton.heightAnchor.constraint(equalToConstant: 50).activate()
////        addCategoryButton.layer.cornerRadius = 15
////        addCategoryButton.backgroundColor = .green.withAlphaComponent(0.6)
////        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
////
////        addStackView.addArrangedSubview(addTransactionButton)
////        addStackView.addArrangedSubview(addCategoryButton)
////        view.addSubview(addStackView)
////        addStackView.bottomAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).activate()
////        addStackView.centerXAnchor.constraint(equalTo: super.view.centerXAnchor).activate()
//////        addStackView.centerYAnchor.constraint(equalTo: super.view.centerYAnchor).activate()
////    }
//
////    func configureEditButton() {
////        editButton.setTitle("Edit", for: .normal)
////        editButton.sizeToFit()
////        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
////        let barButtonItem = UIBarButtonItem(customView: editButton)
////        tabBarController?.navigationItem.rightBarButtonItems = [barButtonItem]
////        view.addSubview(editButton)
////    }
//
////    func configureBalanceStackView() {
////        view.addSubview(balanceStackView)
////        balanceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
////        balanceStackView.heightAnchor.constraint(equalToConstant: 20).activate()
////        balanceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
////        balanceStackView.axis = .horizontal
////        balanceStackView.alignment = .fill
////        balanceStackView.spacing = 40
////        balanceStackView.addArrangedSubview(incomeLabel)
////        balanceStackView.addArrangedSubview(expenceLabel)
////    }
////    func configureDateStackView() {
////        fromLabel.text = "FROM"
////        uptoLabel.text = "UPTO"
////        fromDatePicker.addTarget(self, action: #selector(fromDatePickerPressed(_:)), for: .valueChanged)
////        fromDatePicker.addTarget(self, action: #selector(uptoDatePickerPressed(_:)), for: .valueChanged)
////        fromDatePicker.datePickerMode = .date
////        uptoDatePicker.datePickerMode = .date
////        fromDatePicker.date = fromDate
////        uptoDatePicker.date = uptoDate
////        view.addSubview(dateStackView)
////        dateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
////        dateStackView.heightAnchor.constraint(equalToConstant: 40).activate()
////        dateStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 0).activate()
////        dateStackView.axis = .horizontal
////        dateStackView.alignment = .fill
////        dateStackView.spacing = 3
////
////        dateStackView.addArrangedSubview(fromLabel)
////        dateStackView.addArrangedSubview(fromDatePicker)
////        dateStackView.addArrangedSubview(uptoLabel)
////        dateStackView.addArrangedSubview(uptoDatePicker)
////    }
////
////    func configureTableView() {
////        view.addSubview(tableView)
////        tableView.delegate = self
////        tableView.dataSource = self
////        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
//////        tableView.estimatedRowHeight = UITableView.automaticDimension
////        tableView.heightAnchor.constraint(equalToConstant: 160).activate()
////        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).activate()
////        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).activate()
////        tableView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10).activate()
////        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).activate()
////        refreshControl.addTarget(self, action: #selector(refreshTransactionsList), for: .valueChanged)
////        tableView.refreshControl = refreshControl
////    }
//
////    func configureSearchController() {
////        view.addSubview(searchController.searchBar)
////        searchController.searchResultsUpdater = self
////        searchController.obscuresBackgroundDuringPresentation = false
////        searchController.searchBar.placeholder = "SEARCH IN TRANSACTIONS"
////        searchController.searchBar.sizeToFit()
////        searchController.searchBar.searchBarStyle = .prominent
////        var scopeTitles = ["All"]
////        var i = 1
////        for category in categories {
////            if (i == 5) {
////                break
////            }
////            scopeTitles.append(category)
////            i += 1
////        }
////        searchController.searchBar.scopeButtonTitles = scopeTitles
////        searchController.searchBar.delegate = self
////        tableView.tableHeaderView = searchController.searchBar
////
//////        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
//////        searchController.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).activate()
//////        searchController.searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).activate()
//////        searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
//////        searchController.searchBar.heightAnchor.constraint(equalToConstant: 40).activate()
//////        searchController.searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).activate()
////    }
//
//
////    @objc func editButtonPressed(_ sender: UIBarButtonItem) {
////        if editButton.titleLabel?.text == "Edit" {
////            editButton.setTitle("Done", for: .normal)
////            tableView.setEditing(true, animated: true)
////        } else {
////            editButton.setTitle("Edit", for: .normal)
////            tableView.setEditing(false, animated: true)
////        }
////    }
//
////    @objc func fromDatePickerPressed(_ sender: UIDatePicker) {
////        DispatchQueue.main.async {
////            self.uptoDatePicker.minimumDate = self.fromDatePicker.date
////            self.fromDate = self.fromDatePicker.date
////        }
////        refreshTransactionsList()
////    }
//
////    @objc func uptoDatePickerPressed(_ sender: UIDatePicker) {
////        self.dismiss(animated: true) {
////            self.selectDate()
////            self.uptoDate = self.uptoDatePicker.date
////        }
////        refreshTransactionsList()
////    }
//
////    @objc func addTransactionButtonPressed() {
////        addTransactionVC.completion = {
////            self.refreshTransactionsList()
////        }
////        present(addTransactionVC, animated: true)
////    }
//
////    @objc func addCategoryButtonPressed() {
////        var textField = UITextField()
////        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
////        let dismissAction = UIAlertAction(title: "Cancel", style: .default)
////        let addAction = UIAlertAction(title: "Add category", style: .default) { action in
////            self.categories.append(textField.text!)
////            self.defaults.set(self.categories, forKey: "Categories")
////        }
////        alert.addTextField { alertTextField in
////            alertTextField.placeholder = "Create new category"
////            textField = alertTextField
////        }
////        alert.addAction(dismissAction)
////        alert.addAction(addAction)
////        present(alert, animated: true, completion: nil)
////    }
////
////    private func selectDate() {
//////        refreshTransactionsList()
////        sectionedTransactions.removeAll { section in
////            section.date < fromDatePicker.date || section.date > uptoDatePicker.date
////        }
////        tableView.reloadData()
////        updateBalance()
////    }
//
////    private func fetchTransactions(with request: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()) {
////        if searchText.count == 0 {
////            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", fromDate as NSDate, uptoDate as NSDate)
////        }
////        do {
////            localTransactions = try context.fetch(request)
////        } catch {
////            print("Error fetching local transactions: \(error)")
////        }
////    }
//
////    private func updateBalance() {
////        var income: Double = 0
////        var expense: Double = 0
////        sectionedTransactions.forEach({ section in
////            section.items.forEach { transaction in
////                if transaction.isIncome {
////                    income += transaction.amount
////                } else {
////                    expense += transaction.amount
////                }
////            }
////        })
////        DispatchQueue.main.async {
////            self.incomeLabel.text = "+ ₽\(String(format: "%.2f", income))"
////            self.incomeLabel.textColor = .green
////            self.expenceLabel.text = "- ₽\(String(format: "%.2f", expense))"
////            self.expenceLabel.textColor = .red
////        }
////    }
//
////    //        make transaction cell models fetched from the internet
////    private func makeModels(with diffResponse: DiffResponse) -> [TransactionCellModel] {
////        var transactions = diffResponse.transaction.sorted { $0.date > $1.date }
////        transactions = transactions.filter {
////            self.updateCategories(with: $0.categories?.first.map { $0.title } ?? "")
////            if searchText.count > 0 {
////                if let amount = Int(searchText) {
////                    if (Int($0.income) == amount || Int($0.outcome) == amount) && $0.date >= fromDate && $0.date <= uptoDate {
////                        return true
////                    }
////                } else if $0.payee?.localizedStandardContains(searchText) ?? false && $0.date >= fromDate && $0.date <= uptoDate {
////                    return true
////                }
////                return false
////            } else if $0.date >= fromDate && $0.date <= uptoDate {
////                return true
////            }
////            return false
////        }
////        return transactions.map { TransactionCellModel(transaction: $0) }
////    }
////
////    func updateCategories(with category: String) {
////        if category != "" {
////            if !categories.contains(category) {
////                categories.append(category)
////                defaults.set(categories, forKey: "Categories")
////            }
////        }
////    }
////
////    //        make transaction cell models fetched from the database
////    private func makeModels() -> [TransactionCellModel] {
////        if searchText.count == 0 {
////            fetchTransactions()
////        }
////        var transactionCells = [TransactionCellModel]()
//////        localTransactions = [TransactionData(context: context)]
////        if localTransactions.count > 0 {
////            for transaction in localTransactions {
////                let transactionCell = TransactionCellModel(localTransaction: transaction)
////                transactionCells.append(transactionCell)
////            }
////        }
////        return transactionCells
////    }
//
////    private func groupByDate(transactionCells: [TransactionCellModel]) -> [Section] {
////        let sectionedCells = Dictionary(grouping: transactionCells, by: { (cell) -> Date in
////            let formatter = DateFormatter()
////            formatter.dateFormat = "MM/dd/yyyy"
////            let str = formatter.string(from: cell.date)
////            return formatter.date(from: str) ?? .distantPast
////        }).map {Section(date: $0.key, items: $0.value)}.sorted { $0.date > $1.date }
////        return sectionedCells
////    }
//
////    @objc private func refreshTransactionsList() {
////        self.stateManager?.state = .loading
////
////        var localTransactionsModels = makeModels()
////        Zen.shared.getDiff { [weak self] (result) in
////            guard let self = self else { return }
////            switch result {
////            case .success(let diffResponse):
////                localTransactionsModels.append(contentsOf: self.makeModels(with: diffResponse))
////                self.sectionedTransactions = self.groupByDate(transactionCells: localTransactionsModels)
////                DispatchQueue.main.async {
////                    self.stateManager?.state = .loaded
////                    self.tableView.reloadData()
////                    self.updateBalance()
////                    self.refreshControl.endRefreshing()
////                }
////            case .failure(let error):
////                print("Error loading transactions from the server: \(error.localizedDescription)")
////                //                DispatchQueue.main.async {
////                //                    self.refreshControl.endRefreshing()
////                //                    self.stateManager?.state = .error(error.localizedDescription)
////                //                }
////            }
////        }
////        sectionedTransactions = groupByDate(transactionCells: localTransactionsModels)
////        DispatchQueue.main.async {
////            self.stateManager?.state = .loaded
////            self.tableView.reloadData()
////            self.updateBalance()
////            self.refreshControl.endRefreshing()
////        }
////    }
//}
//
////extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
////    func numberOfSections(in tableView: UITableView) -> Int {
////        sectionedTransactions.count
////    }
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        sectionedTransactions[section].items.count
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else { return UITableViewCell() }
////        let transaction = sectionedTransactions[indexPath.section].items[indexPath.row]
////        cell.configureTransactionCell(with: transaction)
////        return cell
////    }
////
////    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        let transactionDate = sectionedTransactions[section].date
////        if Calendar.current.isDateInYesterday(transactionDate) {
////            return "Yesterday"
////        } else if Calendar.current.isDateInToday(transactionDate) {
////            return "Today"
////        } else if Calendar.current.isDateInTomorrow(transactionDate) {
////            return "Tomorrow"
////        } else {
////            let formatter = DateFormatter()
////            formatter.dateFormat = "MM/dd/yyyy"
////            return formatter.string(from: transactionDate)
////        }
////    }
////
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        //        performSegue(withIdentifier: "ShowTransactionDetail", sender: self)
////        tableView.deselectRow(at: indexPath, animated: true)
////        //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        //        guard let destinationVC = segue.destination as? TransactionDetailViewController else { return }
////        //        guard let indexPath = tableView.indexPathForSelectedRow else { return }
////        //
////        //        destinationVC.transactionCellModel = sectionedTransactions[indexPath.section].items[indexPath.row]
////        //    }
////    }
////    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
////        if sectionedTransactions[indexPath.section].items[indexPath.row].account == "Not specified" {
////            return true
////        } else {
////            return false
////        }
////    }
////
////    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete {
////            context.delete(localTransactions[indexPath.row])
////            localTransactions.remove(at: indexPath.row)
////            do {
////                try context.save()
////            } catch {
////                print("Error removing local transaction from context: \(error)")
////            }
////            refreshTransactionsList()
////        }
//////        if editingStyle == .delete {
//////            if let transaction = localTransactions?[indexPath.row] {
//////                do {
//////                    try realm.write {
//////                        realm.delete(transaction)
//////                    }
//////                } catch {
//////                    print("Error deleting entry")
//////                }
//////                refreshTransactionsList()
//////            }
//////        }
////    }
////}
////
////extension TransactionsVC: UISearchBarDelegate, UISearchResultsUpdating {
////    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
////        //
////    }
////    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
////        searchController.searchBar.showsScopeBar = true
////        searchController.searchBar.sizeToFit()
////    }
////    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
////        searchController.searchBar.showsScopeBar = false
////        searchController.searchBar.sizeToFit()
////    }
////
////    func updateSearchResults(for searchController: UISearchController) {
////        guard let text = searchController.searchBar.text else { return }
////        searchText = text
//////        print("\(#function) - \(searchText)")
////        let request: NSFetchRequest<TransactionData> = TransactionData.fetchRequest()
////        if let amount = Int(text) {
////            request.predicate = NSPredicate(format: "amount >= %f AND amount < %f AND date >= %@ AND date <= %@", Float(amount), Float(amount + 1), fromDatePicker.date as NSDate, uptoDatePicker.date as NSDate)
////        } else {
////            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND title CONTAINS[cd] %@", fromDate as NSDate, uptoDate as NSDate, text)
////        }
////
////        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
////        fetchTransactions(with: request)
////
//////        localTransactions = localTransactions?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "date")
////        refreshTransactionsList()
////    }
////}
