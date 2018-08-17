import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SettingsToggleCell: SettingsCell {
    var toggleView = UISwitch()
    var onToggle: (() -> ())?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        toggleView.addTarget(self, action: #selector(_onToggle), for: .touchUpInside)
        contentView.addSubview(toggleView)
        toggleView.snp.makeConstraints { maker in
            maker.trailing.equalTo(self.disclosureImageView.snp.leading).offset(-SettingsTheme.cellBigMargin)
            maker.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(titleIcon: UIImage?, title: String, isOn: Bool, showDisclosure: Bool, onToggle: (() -> ())? = nil) {
        super.bind(titleIcon: titleIcon, title: title, showDisclosure: showDisclosure)
        self.onToggle = onToggle
        toggleView.isOn = isOn
    }

    override func bind(titleIcon: UIImage?, title: String, showDisclosure: Bool) {
        fatalError("use bind with toggle")
    }

    @objc func _onToggle() {
        onToggle?()
    }

}