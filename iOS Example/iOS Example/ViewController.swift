//
//  ViewController.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/5/22.
//

import UIKit
import SnapKit

fileprivate final class Cell: UITableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(Cell.classForCoder()))
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.rowHeight = 55
        return tableView
    }()
    
    private var models: [Model] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Demo"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let model1 = Model(title: "General", action: GeneralAction())
        let model2 = Model(title: "TextEdit", action: TextEditAction())
        let model3 = Model(title: "Multi", action: MultiAction())
        
        models = [model1, model2, model3]
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(Cell.classForCoder())) as? Cell else { return UITableViewCell() }
        let model = models[indexPath.row]
        cell.label.text = model.title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        model.action.action()
    }
}
