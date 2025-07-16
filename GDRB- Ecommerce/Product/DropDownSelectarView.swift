//
//  DropDownSelectarView.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 16/07/25.
//

import UIKit

class DropdownSelectorView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var items: [String] = []
    private var onSelect: ((String) -> Void)?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupTableView()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
        addSubview(tableView)
    }

    func show(over parent: UIView, anchor: UITextField, items: [String], onSelect: @escaping (String) -> Void) {
        self.items = items
        self.onSelect = onSelect

        parent.addSubview(self)
        frame = parent.bounds
        
        let anchorFrame = anchor.convert(anchor.bounds, to: parent)
        let maxHeight = min(CGFloat(items.count * 40), 200)
        let spaceBelow = parent.bounds.height - anchorFrame.maxY
        let showAbove = spaceBelow < maxHeight

        let tableY = showAbove ? anchorFrame.minY - maxHeight : anchorFrame.maxY

        tableView.frame = CGRect(
            x: anchorFrame.origin.x,
            y: tableY,
            width: anchorFrame.width,
            height: maxHeight
        )

        tableView.reloadData()
    }


  

    // MARK: - UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
            cell.configure(with: item)
            return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(items[indexPath.row])
        self.removeFromSuperview()
    }
}

class DropdownCell: UITableViewCell {

    // Optional: You can add a custom label if needed
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Initializer for programmatic UI
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    // Required initializer for storyboard/XIB (not used here)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        // Optional: Clear existing views if reused improperly
        contentView.subviews.forEach { $0.removeFromSuperview() }

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with text: String) {
        titleLabel.text = text
    }
}
