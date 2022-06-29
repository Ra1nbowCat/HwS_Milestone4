//
//  ViewController.swift
//  Milestone4
//
//  Created by Илья Лехов on 29.06.2022.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var people = [Photos]()
    var imageNameObserver: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addName))
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        let person = people[indexPath.item]
        cell.textLabel?.text = person.name
        return cell
    }
    
    @objc func addName() {
        let ac = UIAlertController(title: "Rename picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            self?.imageNameObserver = newName
            self?.addNewPerson()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        if let newImage = imageNameObserver {
            if !newImage.isEmpty {
                let person = Photos(name: newImage, photoName: imageName)
                people.append(person)
                tableView.reloadData()
            } else {
                let person = Photos(name: "Empty name", photoName: imageName)
                people.append(person)
                tableView.reloadData()
            }
        }
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let path = getDocumentsDirectory().appendingPathComponent(person.photoName)
        let ac = UIAlertController(title: "Rename picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            self?.people[indexPath.item].name = newName
            self?.tableView.reloadData()
        })
                     
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Delete picture", style: .default) { [weak self] _ in
            print("Hi")
            self?.people.remove(at: indexPath.item)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        ac.addAction(UIAlertAction(title: "See full picture", style: .default) { [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PictureViewController") as? PictureViewController {
                print(path.path)
                vc.pictureName = path.path
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
                     
        present(ac, animated: true)
    }
}

