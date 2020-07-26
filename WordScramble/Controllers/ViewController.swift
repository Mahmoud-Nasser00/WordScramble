//
//  ViewController.swift
//  WordScramble
//
//  Created by Mahmoud Nasser on 7/24/20.
//  Copyright © 2020 Mahmoud Nasser. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarBtnItem()
        loadAllWords()
        startGame()
    }

    func addBarBtnItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addword))
    }

    @objc func addword() {
        let ac = UIAlertController(title: "add word", message: "please add word", preferredStyle: .alert)
        ac.addTextField()
        let addAction = UIAlertAction(title: "Submit", style: .default) { [weak self , weak ac] (_) in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submitAnswer(answer: answer)
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(addAction)
        present(ac, animated: true)
    }

    
    func submitAnswer(answer:String){
        let loweredAnswer = answer.lowercased()
        if loweredAnswer.isPossible() && loweredAnswer.isOriginal() && loweredAnswer.isReal (){
            usedWords.insert(loweredAnswer, at: 0)
//            tableView.reloadData()
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func loadAllWords() {
        guard let allwordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else { return }
        if let allWords = try? String(contentsOf: allwordsURL).components(separatedBy: "\n") {
            self.allWords = allWords
        }
    }

    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

}

