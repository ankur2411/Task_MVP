//
//  JokesViewController.swift
//  Task
//
//  Created by Ankur Verma on 20/09/23.
//

import UIKit

class JokesViewController: UIViewController,JokePresenterDelegate {
    
    private let presenter = JokePresenter()
    private var jokeData = [Joke]()
    private var updatedJokeData = [Joke](){
        didSet{
            DispatchQueue.main.async {
                self.tblView_JokeList.reloadData()
            }
        }
    }
    
    private lazy var tblView_JokeList: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: JokeCell.className, bundle: nil)
        table.register(nib, forCellReuseIdentifier: JokeCell.className)
        table.tableHeaderView = UIView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        return table
    }()
    
    var isNewJokeAnimated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        self.title = "Jokes"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.yellow]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.view.addSubview(tblView_JokeList)
        tblView_JokeList.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        tblView_JokeList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tblView_JokeList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tblView_JokeList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        presenter.setDelegate(delegate: self)
        self.updatedJokeData = presenter.startTimer()
    }
    
    func presentJoke(joke: Joke?) {
        if (UserDefaults.standard.object(forKey: KEY_JOKE_DATA) != nil){
            if let jokeData = UserDefaults.standard.data(forKey: KEY_JOKE_DATA){
                do {
                    let decoder = JSONDecoder()
                    let jokes = try decoder.decode([Joke].self, from: jokeData)
                    self.jokeData = jokes
                    if let joke = joke{
                        getUpdatedData(withJoke: joke)
                    }
                } catch {
                    print("Unable to Decode Data (\(error))")
                }
            }
        }
        else{
            if let joke = joke{
                getUpdatedData(withJoke: joke)
            }
        }
    }
    
    deinit {
        presenter.stopTimer()
    }

    func getUpdatedData(withJoke:Joke){
        self.jokeData.insert(withJoke, at: 0)
        self.updatedJokeData = presenter.updateJokeList(jokesData: self.jokeData)
        self.jokeData = self.updatedJokeData
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.updatedJokeData)
            UserDefaults.standard.set(data, forKey: KEY_JOKE_DATA)
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode Data (\(error))")
        }
    }
}


extension JokesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedJokeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JokeCell.className, for: indexPath) as! JokeCell
        cell.selectionStyle = .none
        cell.configure(model: updatedJokeData[indexPath.row])
        return cell
    }
}

extension JokesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index",indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && !isNewJokeAnimated {
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1.0
            }
            isNewJokeAnimated = false
        }
    }
}
