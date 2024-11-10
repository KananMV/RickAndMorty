
import UIKit
import SnapKit
import Kingfisher

class CharactersCell: UITableViewCell {
    let characterImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    let characterName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        return label
    }()
    let statusIndicator: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = .green
        indicator.layer.cornerRadius = 3
        indicator.clipsToBounds = true
        return indicator
    }()
    let characterStatus: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let characterGender: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let lastLocation: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "Last known location:"
        return label
    }()
    let characterLocation: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    func configure(with character: Character) {
        characterName.text = character.name
        characterStatus.text = character.status
        characterLocation.text = character.location.name
        characterGender.text = " - \(character.gender)"
        switch character.status.lowercased() {
        case "alive":
            statusIndicator.backgroundColor = .green
        case "dead":
            statusIndicator.backgroundColor = .red
        default:
            statusIndicator.backgroundColor = .black
        }
        if let url = URL(string: character.image) {
            characterImage.kf.setImage(with: url)
        }
    }
    func setup(){
        contentView.backgroundColor = .gray
        contentView.addSubview(characterImage)
        contentView.addSubview(characterName)
        contentView.addSubview(statusIndicator)
        contentView.addSubview(characterStatus)
        contentView.addSubview(characterGender)
        contentView.addSubview(lastLocation)
        contentView.addSubview(characterLocation)
        characterImage.snp.makeConstraints{ make in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        characterName.snp.makeConstraints{make in
            make.top.equalTo(contentView.snp.top).offset(15)
            make.leading.equalTo(characterImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        statusIndicator.snp.makeConstraints{make in
            make.width.equalTo(6)
            make.height.equalTo(6)
            make.centerY.equalTo(characterStatus.snp.centerY)
            make.leading.equalTo(characterName.snp.leading)
        }
        characterStatus.snp.makeConstraints{make in
            make.top.equalTo(characterName.snp.bottom).offset(5)
            make.leading.equalTo(statusIndicator.snp.trailing).offset(5)
        }
        characterGender.snp.makeConstraints{make in
            make.centerY.equalTo(characterStatus.snp.centerY)
            make.leading.equalTo(characterStatus.snp.trailing).offset(5)
        }
        lastLocation.snp.makeConstraints{make in
            make.top.equalTo(characterGender.snp.bottom).offset(15)
            make.leading.equalTo(characterImage.snp.trailing).offset(10)
        }
        characterLocation.snp.makeConstraints{make in
            make.top.equalTo(lastLocation.snp.bottom).offset(5)
            make.leading.equalTo(lastLocation.snp.leading)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
