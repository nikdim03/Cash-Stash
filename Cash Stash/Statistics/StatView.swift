//
//  StatView.swift
//  Cash Stash
//
//  Created by Dmitriy on 1/5/23.
//

import UIKit
import SceneKit

//view controller
//protocol
//ref to presenter

//MARK: - StatView
protocol StatViewProtocol {
    var presenter: StatPresenterProtocol? { get set }
    var tableView: UITableView { get set }
    var categories: [String] { get set }
    var incomeExpenseLabel: UILabel { get set }
    var sectionedTransactions: [Section] { get set }
    var localTransactions: [TransactionData] { get set }
    var fromDate: Date { get set }
    var uptoDate: Date { get set }
    var refreshControl: UIRefreshControl { get set }
    var dataFetched: Bool { get set }
    var blurView: UIVisualEffectView { get set }
    var scnView: SCNView { get set }
    func firstConfig()
}

class StatView: UIViewController, StatViewProtocol {
    var presenter: StatPresenterProtocol?
    @UsesAutoLayout
    var chartView = ChartView()
    @UsesAutoLayout
    var tableView = UITableView()
    @UsesAutoLayout
    var fromDatePicker = UIDatePicker()
    @UsesAutoLayout
    var uptoDatePicker = UIDatePicker()
    @UsesAutoLayout
    var incomeExpenseLabel = UILabel()
    @UsesAutoLayout
    var dateStackView = UIStackView()
    @UsesAutoLayout
    var balanceStackView = UIStackView()
    @UsesAutoLayout
    var editButton = UIButton()
    @UsesAutoLayout
    var addStackView = UIStackView()
    @UsesAutoLayout
    var addStatsactionButton = UIButton()
    @UsesAutoLayout
    var addCategoryButton = UIButton()
    @UsesAutoLayout
    var incomeExpenseSelector = UISegmentedControl(items: ["INCOME", "EXPENSE"])
    @UsesAutoLayout
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    @UsesAutoLayout
    var scnView = SCNView()
    
    var fromDate = Date() - 30 * 24 * 60 * 60
    var uptoDate = Date() + 24 * 60 * 60
    let fromLabel = UILabel()
    let uptoLabel = UILabel()
    var refreshControl = UIRefreshControl()
    var localTransactions = [TransactionData]()
    var sectionedTransactions = [Section]()
    var categories = [String]()
    var dataDict = Dictionary<String, Int>()
    var dataFetched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showPig() // already on the main thread
        presenter?.startRefreshingTransactions(of: incomeExpenseSelector.selectedSegmentIndex == 1)
    }
    
    func firstConfig() {
        configureChartView()
        configureIncomeExpenseSelector()
        presenter?.initCategoriesFromDefaults()
        configureBalanceStackView()
        configureDateStackView()
        configureTableView()
    }
    
    func configureChartView() {
        presenter!.chartView = chartView
        view.addSubview(chartView)
        
        let widthConstraint = chartView.widthAnchor.constraint(equalToConstant: 300)
        let heightConstraint = chartView.heightAnchor.constraint(equalToConstant: 300)
        let centerXConstraint = chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, centerXConstraint, topConstraint])
        chartView.handleTap(UITapGestureRecognizer())
        chartView.draw(.zero)
    }
    
    func configureIncomeExpenseSelector() {
        view.addSubview(incomeExpenseSelector)
        incomeExpenseSelector.selectedSegmentIndex = 0
        incomeExpenseSelector.topAnchor.constraint(equalTo: chartView.topAnchor, constant: -30).activate()
        incomeExpenseSelector.heightAnchor.constraint(equalToConstant: 30).activate()
        incomeExpenseSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        incomeExpenseSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        incomeExpenseSelector.addTarget(self, action: #selector(switchType), for: .valueChanged)
    }
        
    func configureBalanceStackView() {
        view.addSubview(balanceStackView)
        balanceStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        balanceStackView.heightAnchor.constraint(equalToConstant: 20).activate()
        balanceStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor).activate()
        balanceStackView.axis = .horizontal
        balanceStackView.alignment = .fill
        balanceStackView.spacing = 40
        balanceStackView.addArrangedSubview(incomeExpenseLabel)
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
        dateStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor).activate()
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
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).activate()
        refreshControl.addTarget(self, action: #selector(userSwopeDown), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
    
    @objc func switchType() {
        DispatchQueue.main.async {
            self.showPig()
        }
        presenter?.startRefreshingTransactions(of: incomeExpenseSelector.selectedSegmentIndex == 1)
//        chartView.handleTap(UITapGestureRecognizer())
        chartView.draw(.zero)
    }

    @objc func fromDatePickerPressed(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.uptoDatePicker.minimumDate = self.fromDatePicker.date
            self.fromDate = self.fromDatePicker.date
            self.showPig()
        }
        presenter?.startRefreshingTransactions(of: incomeExpenseSelector.selectedSegmentIndex == 1)
    }
    
    @objc func uptoDatePickerPressed(_ sender: UIDatePicker) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.selectDate()
                self.uptoDate = self.uptoDatePicker.date
            }
            self.showPig()
        }
        presenter?.startRefreshingTransactions(of: incomeExpenseSelector.selectedSegmentIndex == 1)
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
    
    @objc func userSwopeDown() {
        DispatchQueue.main.async {
            self.showPig()
        }
        presenter?.startRefreshingTransactions(of: incomeExpenseSelector.selectedSegmentIndex == 1)
    }

}


//MARK: - ChartView
protocol ChartViewProtocol {
    var presenter: StatPresenterProtocol? { get set }
    var data: [Int] { get set }
    var categories: [String] { get set }
    var colors: [UIColor] { get set }
}

class ChartView: UIView, ChartViewProtocol {
    var presenter: StatPresenterProtocol?
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
//    var dataDict = Dictionary<String, Int>()
    var data = [Int]()
    var categories = [String]()
    var colors: [UIColor] = [UIColor(red: 103/255, green: 97/255, blue: 244/255, alpha: 1), UIColor(red: 58/255, green: 237/255, blue: 237/255, alpha: 1), UIColor(red: 237/255, green: 93/255, blue: 240/255, alpha: 1), UIColor(red: 0.00, green: 0.00, blue: 0.80, alpha: 1.00)]
    @UsesAutoLayout
    var labelStackView = UIStackView()
    var selectedSegmentIndex: Int? {
        didSet {
            setNeedsDisplay()  // redraw the view to reflect the changes
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear  // set the background color to clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.clear  // set the background color to clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
        
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let dx = location.x - center.x
        let dy = location.y - center.y
        let distance = sqrt(dx * dx + dy * dy)
        
        if distance > radius {
            // the tap was outside the chart
            selectedSegmentIndex = nil
            return
        }
        let angle = .pi / 2 - atan2(dx, dy)  // angle in radians
        var startAngle: CGFloat = -.pi / 2  // start at the top of the chart
        for (index, value) in data.enumerated() {
            let endAngle = startAngle + CGFloat(value) / 100 * .pi * 2
            if angle >= startAngle && angle < endAngle {
                // the tap was inside the pie chart segment with index `index`
                if selectedSegmentIndex == index {
                    // if the pie chart segment is already selected, deselect it
                    selectedSegmentIndex = nil
                } else {
                    // select the pie chart segment with index `index`
                    selectedSegmentIndex = index
                }
                break
            }
            startAngle = endAngle
        }
    }
    
    func configureLabelStakView() {
        // add the stack view to the view hierarchy
        self.addSubview(labelStackView)
        // set up constraints for the stack view
        labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20).activate()
        labelStackView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).activate()
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
    }
        
    override func draw(_ rect: CGRect) {
        data.removeAll()
        categories.removeAll()
        labelStackView.subviews.forEach { $0.removeFromSuperview() }
        presenter?.setPercentage()
        configureLabelStakView()
        let radius = min(bounds.width, bounds.height) / 2 * 0.9
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        var startAngle: CGFloat = -.pi / 2  // start at the top of the chart
        var labels: [UILabel] = []
        for (index, val) in data.enumerated() {
            let endAngle = startAngle + CGFloat(val) / 100 * .pi * 2
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: center)
            path.close()

            // set the color for the pie chart segment
            let color = colors[index]
            color.setFill()
            path.fill()

            // add a white stroke to the pie chart segment
            let strokeColor = UIColor.white
            strokeColor.setStroke()
            path.lineWidth = 2
            path.stroke()
            path.close()

            if let selectedSegmentIndex = selectedSegmentIndex, index == selectedSegmentIndex {
                // the pie chart segment is selected, draw a bigger version of it
                let expandedPath = UIBezierPath(arcCenter: center, radius: radius * 1.1, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                expandedPath.addLine(to: center)
                color.setFill()
                expandedPath.fill()

                // add a white stroke to the pie chart segment
                expandedPath.lineWidth = 2
                expandedPath.stroke()
                expandedPath.close()
            }
            startAngle = endAngle

            // create a label for the pie chart segment
            let label = UILabel()
            label.text = categories[index]
            label.textColor = color
            if index == selectedSegmentIndex {
                label.layer.masksToBounds = true
                label.font = UIFont.boldSystemFont(ofSize: 12)
                label.backgroundColor = .white
                label.layer.cornerRadius = label.bounds.height / 2
            } else {
                label.font = UIFont.systemFont(ofSize: 12)
                label.backgroundColor = .clear
            }
            if label.text == "" {
                label.text = "Not specified"
            }
            labels.append(label)
        }
        // add the labels to the stack view
        let sortedData = data.sorted(by: >)
        if data.count > 4 {
            for i in 0..<5 {
                labelStackView.addArrangedSubview(labels[data.firstIndex(of: sortedData[i])!])
            }
        } else {
            for label in labels {
                labelStackView.addArrangedSubview(label)
            }
        }
    }
}


//MARK: - StatView Extensions
extension StatView: UITableViewDelegate, UITableViewDataSource {
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
        //        performSegue(withIdentifier: "ShowStatsactionDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        guard let destinationVC = segue.destination as? StatsactionDetailViewController else { return }
        //        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        //
        //        destinationVC.transactionCellModel = sectionedStatsactions[indexPath.section].items[indexPath.row]
        //    }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if sectionedTransactions[indexPath.section].items[indexPath.row].account == "Not specified" {
            return true
        } else {
            return false
        }
    }
}
