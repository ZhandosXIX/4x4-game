//
//  ViewController.swift
//  4x4
//
//  Created by zhandos on 19.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var state = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var imageNames = [ "red", "blue", "brown", "green", "orange", "pink", "purple", "yellow",  "red", "blue", "brown", "green", "orange", "pink", "purple", "yellow"]
    var oldImage: UIImage? = nil

        var openedButtons: [UIButton] = []
        var matchedPairs: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imageNames.shuffle()
    }
    
    
    @IBAction func game(_ sender: UIButton) {
        let tag = sender.tag

                guard tag >= 1 && tag <= imageNames.count else {
                    print("Invalid tag:", tag)
                    return
                }

                let imageName = imageNames[tag - 1]
                print("Tag:", tag, "Image Name:", imageName)

                if openedButtons.contains(sender) || matchedPairs.contains(imageName) {
                    return
                }

                if let lastOpenedButton = openedButtons.last {
                    let lastImageName = imageNames[lastOpenedButton.tag - 1]

                    if imageName == lastImageName {
                        openedButtons.append(sender)
                        matchedPairs.insert(imageName)

                        sender.isEnabled = false
                        lastOpenedButton.isEnabled = false

                        if matchedPairs.count == imageNames.count / 2 {
                            showGameOverAlert()
                        }
                        return
                    } else {
                        closeButton(lastOpenedButton)
                    }
                }

                openButton(sender, withImageName: imageName)
            }

            func openButton(_ button: UIButton, withImageName imageName: String) {
                button.setBackgroundImage(nil, for: .normal)

                DispatchQueue.main.async {
                    if let image = UIImage(named: imageName) {
                        button.setBackgroundImage(image, for: .normal)
                    }
                }

                openedButtons.append(button)
                oldImage = button.backgroundImage(for: .normal)
            }

            func closeButton(_ button: UIButton) {
                button.setBackgroundImage(oldImage, for: .normal)

                DispatchQueue.main.async {
                    if let image = UIImage(named: "?") {
                        button.setBackgroundImage(image, for: .normal)
                    }
                }

                if let index = openedButtons.firstIndex(of: button) {
                    openedButtons.remove(at: index)
                }
            }

            func startNewGame() {
                openedButtons.forEach { $0.isEnabled = true }
                openedButtons.removeAll()
                matchedPairs.removeAll()
                imageNames.shuffle()
            }

            func showGameOverAlert() {
                let alert = UIAlertController(title: "Congratulations!", message: "You've matched all colors. Do you want to play again?", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.startNewGame()
                }))

                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                present(alert, animated: true, completion: nil)
            }
        }
