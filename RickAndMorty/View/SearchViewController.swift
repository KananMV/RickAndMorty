
import UIKit
import SnapKit
import Combine

class SearchViewController: UIViewController{
    
    private let searchController  = UISearchController()
    let viewModel = CharacterViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var cancellable: AnyCancellable?
    
    lazy var themeSwitch: UISwitch = {
        let tSwithc = UISwitch()
        tSwithc.isOn = traitCollection.userInterfaceStyle == .dark
        tSwithc.addTarget(self, action: #selector(didChangeThemeSwitch(_:)), for: .valueChanged)
        return tSwithc
    }()
    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.addArrangedSubview(genderFiter)
        stackView.addArrangedSubview(speciesFilter)
        return stackView
    }()
    private lazy var genderFiter: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemBlue
        stackView.layer.cornerRadius = 16
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.addArrangedSubview(genderIcon)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(genderChevron)
        return stackView
    }()
    private lazy var genderTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    private let genderIcon: UIImageView = {
        let iV = UIImageView()
        iV.image = UIImage(named: "genderIcon")
        return iV
    }()
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let genderChevron: UIImageView = {
        let iV = UIImageView()
        iV.image = UIImage(systemName: "chevron.up")
        iV.tintColor = .white
        return iV
    }()
    
    private lazy var speciesFilter: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .systemBlue
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.layer.cornerRadius = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 5
        stackView.addArrangedSubview(speciesIcon)
        stackView.addArrangedSubview(speciesLabel)
        stackView.addArrangedSubview(speciesChevron)
        return stackView
    }()
    private let speciesIcon: UIImageView = {
        let iV = UIImageView()
        iV.image = UIImage(named: "speciesIcon")
        iV.tintColor = .white
        return iV
    }()
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.text = "Species"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let speciesChevron: UIImageView = {
        let iV = UIImageView()
        iV.tintColor = .white
        iV.image = UIImage(systemName: "chevron.up")
        return iV
    }()
    private lazy var speciesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharactersCell.self, forCellReuseIdentifier: "CharactersCell")
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Rick And Morty"
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = .black
        view.backgroundColor = .white
        setup()
        setBindings()
    }
    func setup(){
        view.backgroundColor = UIColor(named: "viewBack")
        searchController.delegate = self
        view.addSubview(charactersTableView)
        fetch()
        view.addSubview(filterStackView)
        view.addSubview(genderTableView)
        view.addSubview(speciesTableView)
        view.addSubview(themeSwitch)
        navigationItem.title = "Rick And Morty"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "viewBack")
        searchController.searchBar.tintColor = .gray
        let genderTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStackTap(_:)))
        genderFiter.addGestureRecognizer(genderTapGesture)
        let speciesTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStackTap(_:)))
        speciesFilter.addGestureRecognizer(speciesTapGesture)
        setupCons()
    }
    
    private func setBindings() {
        viewModel.$success
            .compactMap {$0} // nil
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                guard let self else { return }
                switch success {
                case .fetchChar:
                    break
                case .fetchCharByTitle:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func fetch(){
        viewModel.fetchCharacters{
            print(self.viewModel.characters.count)
            self.charactersTableView.reloadData()
        }
    }
    func setupCons(){
        themeSwitch.snp.makeConstraints{make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        filterStackView.snp.makeConstraints{make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(themeSwitch.snp.bottom).offset(10)
            make.leading.greaterThanOrEqualTo(view.snp.leading).offset(16)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-16)
        }
        genderIcon.snp.makeConstraints{make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        genderChevron.snp.makeConstraints{make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        speciesIcon.snp.makeConstraints{make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        speciesChevron.snp.makeConstraints{make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        genderTableView.snp.makeConstraints{make in
            make.top.equalTo(genderFiter.snp.bottom)
            make.leading.equalTo(genderFiter.snp.leading)
            make.trailing.equalTo(genderFiter.snp.trailing)
            make.height.equalTo(viewModel.genderOptions.count*50)
        }
        speciesTableView.snp.makeConstraints{make in
            make.top.equalTo(speciesFilter.snp.bottom)
            make.leading.equalTo(speciesFilter.snp.leading)
            make.trailing.equalTo(speciesFilter.snp.trailing)
            make.height.equalTo(viewModel.speciesOptions.count*50)
        }
        charactersTableView.snp.makeConstraints{make in
            make.top.equalTo(filterStackView.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    @objc func didChangeThemeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            view.window?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        } else {
            view.window?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: "isDarkMode")
        }
    }
    @objc func handleStackTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        if tappedView == genderFiter {
            genderTableView.isHidden.toggle()
            genderChevron.image = UIImage(systemName: genderTableView.isHidden ? "chevron.up" : "chevron.down")
            speciesTableView.isHidden = true
            speciesChevron.image = UIImage(systemName: "chevron.up")
        } else if tappedView == speciesFilter {
            speciesTableView.isHidden.toggle()
            speciesChevron.image = UIImage(systemName: speciesTableView.isHidden ? "chevron.up" : "chevron.down")
            genderTableView.isHidden = true
            genderChevron.image = UIImage(systemName: "chevron.up")
        }
        
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case genderTableView:
            return viewModel.genderOptions.count
        case speciesTableView:
            return viewModel.speciesOptions.count
        case charactersTableView:
            return viewModel.characters.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case genderTableView:
            let cell = genderTableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.filterLabel.text = viewModel.genderOptions[indexPath.row]
            cell.selectionStyle = .none
            return cell
        case speciesTableView:
            let cell = speciesTableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.filterLabel.text = viewModel.speciesOptions[indexPath.row]
            cell.selectionStyle = .none
            return cell
        case charactersTableView:
            let cell = charactersTableView.dequeueReusableCell(withIdentifier: "CharactersCell", for: indexPath) as! CharactersCell
            let character = viewModel.characters[indexPath.row]
            cell.configure(with: character)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == genderTableView {
            if genderLabel.text == "Gender" && viewModel.genderOptions[indexPath.row] == "None" {
                    return 0
                }
            }
        else if tableView == speciesTableView{
            if speciesLabel.text == "Species" && viewModel.speciesOptions[indexPath.row] == "None" {
                return 0
            }
        }
        else {
            return 150
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case genderTableView:
            viewModel.currentPage = 1
            let selectedGender = viewModel.genderOptions[indexPath.row]
            genderLabel.text = selectedGender == "None" ? "Gender" : selectedGender
            genderTableView.isHidden = true
            viewModel.filterCharactersByGender(gender: selectedGender == "None" ? nil : selectedGender) {
                self.charactersTableView.reloadData()
            }
            
        case speciesTableView:
            viewModel.currentPage = 1
            let selectedSpecies = viewModel.speciesOptions[indexPath.row]
            speciesLabel.text = selectedSpecies == "None" ? "Species" : selectedSpecies
            speciesTableView.isHidden = true
            viewModel.filterCharactersBySpecies(species: selectedSpecies == "None" ? nil : selectedSpecies) {
                self.charactersTableView.reloadData()
            }
        case charactersTableView:
            let selectedCharacter = viewModel.characters[indexPath.row]
            let detailVC = DetailsViewController()
            detailVC.character = selectedCharacter
            navigationController?.pushViewController(detailVC, animated: true)
            
        default:
            break
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height

            if offsetY > contentHeight - height {
                viewModel.fetchMoreCharacters {
                    self.charactersTableView.reloadData()
                }
            }
        }
}
extension SearchViewController: UISearchControllerDelegate,UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.currentPage = 1
        viewModel.searchedTitle = searchText
        viewModel.fetchCharactersByTitle { characters in
            DispatchQueue.main.async {
                self.viewModel.characters = characters
                self.charactersTableView.reloadData()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchedTitle = nil
        viewModel.currentPage = 1
        viewModel.fetchCharactersByTitle() { characters in
            DispatchQueue.main.async {
                self.viewModel.characters = characters
                self.charactersTableView.reloadData()
            }
        }
    }
}
