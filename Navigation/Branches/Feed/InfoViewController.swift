
import UIKit

class InfoViewController: UIViewController {

    private var jsonTitle: String = ""
    
//MARK: - ITEMs
    private let infoDefaultImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "darthvader")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var jsonTask1Label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = .blue
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var jsonTask2Label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = .brown
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return $0
    }(UILabel())
    
    private lazy var jsonTask3Label: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = .purple
        $0.backgroundColor = .clear
        $0.isEditable = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return $0
    }(UITextView())
    
    private lazy var infoButton: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("info.runAwayButton", comment: ""),
            tapAction: { [weak self] in self?.tapInfoButton() })
        button.layer.cornerRadius = 4
        return button
    }()

//MARK: - INITs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        showDefaultItems()
        receiveJSON()
        decodeJSON()
        decodeJSON2()
    }

//MARK: - METHODs
    @objc private func tapInfoButton() {
        let alert = UIAlertController(title: NSLocalizedString("info.allBadAlert", comment: ""), message: NSLocalizedString("info.allHandsAlert", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("info.polundraAlert", comment: ""), style: .default) {
            _ in self.dismiss(animated: true)
            print("Ок")
        }
        let cancel = UIAlertAction(title: NSLocalizedString("info.allClearAlert", comment: ""), style: .destructive) {
            _ in print(NSLocalizedString("cancel", comment: ""))
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    // Homework.2.1 JSON deserialization
    func receiveJSON() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/9") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data)

                    if let castedDictionary = dictionary as? [String: Any] {
                        if let title = castedDictionary["title"] as? String {
                            OperationQueue.main.addOperation { [weak self] in
                                self?.jsonTask1Label.text = ["TITLE:", title]
                                    .compactMap({ $0 })
                                    .joined(separator: " ")
                            }
                        }
                    }
                } catch {
                    print("⛔️ error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    // Homework.2.2 JSON decode
    func decodeJSON() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let planet = try JSONDecoder().decode(PlanetModel.self, from: data)
                    OperationQueue.main.addOperation { [weak self] in
                        self?.jsonTask2Label.text = [NSLocalizedString("info.orbitalPeriod", comment: ""), planet.orbitalPeriod, NSLocalizedString("info.days", comment: "")]
                            .compactMap({ $0 })
                            .joined(separator: " ")
                    }
                } catch {
                    print("⛔️ error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    // Homework.2.3 JSON decode (with spectacular enormous star)
    func decodeJSON2() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }
        var array: [String] = []
        var listOfResidents: [String] = [NSLocalizedString("info.listOfResidents", comment: "")]

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let planet = try JSONDecoder().decode(PlanetModel.self, from: data)
                array = planet.residents

                for value in array {
                    guard let url = URL(string: value) else { return }

                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data else { return }
                        do {
                            let planet = try JSONDecoder().decode(CitizenModel.self, from: data)
                            listOfResidents.append(planet.name)
                            OperationQueue.main.addOperation { [weak self] in
                                self?.jsonTask3Label.text = listOfResidents
                                    .compactMap({ $0 })
                                    .joined(separator: "\n")
                            }
                        } catch {
                            print("⛔️ error: \(error.localizedDescription)")
                        }
                    }
                    task.resume()
                }
            } catch {
                print("⛔️ error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func showDefaultItems() {
        [infoDefaultImage, jsonTask1Label, jsonTask2Label, jsonTask3Label, infoButton].forEach{ view.addSubview($0) }
    
        NSLayoutConstraint.activate([
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: screenWidth),
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            
            infoDefaultImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            infoDefaultImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            infoDefaultImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            infoDefaultImage.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -8),
            
            jsonTask1Label.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 8),
            jsonTask1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            jsonTask1Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            jsonTask1Label.heightAnchor.constraint(equalToConstant: 22),
            
            jsonTask2Label.topAnchor.constraint(equalTo: jsonTask1Label.bottomAnchor, constant: 6),
            jsonTask2Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            jsonTask2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            jsonTask2Label.heightAnchor.constraint(equalToConstant: 22),
            
            jsonTask3Label.topAnchor.constraint(equalTo: jsonTask2Label.bottomAnchor, constant: 6),
            jsonTask3Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            jsonTask3Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            jsonTask3Label.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}
