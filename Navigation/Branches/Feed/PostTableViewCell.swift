//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Diego Abramoff on 12.06.23.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    var name: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        show()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func show() {
        contentView.addSubview(name)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: contentView.topAnchor),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            name.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }

    func setupCell(_ cell: String) {
        name.text = cell
    }
}
