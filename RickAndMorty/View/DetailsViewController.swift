

import UIKit
import SnapKit
import Kingfisher

class DetailsViewController: UIViewController {
    var character: Character?
    
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private let characterGender: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 20
        view.addArrangedSubview(posterImageView)
        view.addArrangedSubview(characterNameLabel)
        view.addArrangedSubview(characterGender)
        view.addArrangedSubview(statusLabel)
        view.addArrangedSubview(speciesLabel)
        view.addArrangedSubview(locationLabel)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCons()
        displayCharacterDetails()
    }
    func setup(){
        view.backgroundColor = UIColor(named: "viewBack")
        view.addSubview(stackView)
    }
    func setupCons(){
        stackView.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        posterImageView.snp.makeConstraints{make in
            make.width.height.equalTo(200)
        }
    }
    private func displayCharacterDetails() {
        guard let character = character else { return }
        if let url = URL(string: character.image) {
            posterImageView.kf.setImage(with: url)
        }
        characterNameLabel.text = character.name
        characterGender.text = character.gender
        statusLabel.text = character.status
        speciesLabel.text = character.species
        locationLabel.text = character.location.name
        
    }
}
