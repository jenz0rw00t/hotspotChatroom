//
//  ChatroomTableViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-12.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class ChatroomTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var chatrooms = [Chatroom]()
    var currentUser: User?
    let locationManager = CLLocationManager()
    let proximityToChatroom: Double = 40 // How close in meters you need to be able to join a chatroom

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = CurrentUserHandler.shared.currentUser
        
        setupRefreshControl()
        checkLocationServices()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        currentUser = CurrentUserHandler.shared.currentUser
        if LogInHelper.getCurrentUserID() == nil {
            self.refreshControl?.endRefreshing()
            self.tabBarController!.performSegue(withIdentifier: "signInSegueNoAnimation", sender: nil)
        }
        searchForNearbyChatrooms()
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        createChatroomAlert()
    }
    
    // MARK: - RefreshControl
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Searching for nearby chatrooms...")
        refreshControl?.addTarget(self, action: #selector(dragDownUpdate) , for: .valueChanged)
    }
    
    @objc func dragDownUpdate() {
        searchForNearbyChatrooms()
    }
    
    // MARK: - Create chatroom and search for chatroom functions
    
    func createChatroomAlert() {
        
        let alert = UIAlertController(title: "Create a new Chatroom", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Chatroom name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            guard let chatroomName = alert.textFields?.first?.text else { return }
            guard let currentUsername = self.currentUser?.username else { return }
            self.createChatroom(name: chatroomName, creatorUsername: currentUsername)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func createChatroom(name: String, creatorUsername: String) {
        guard let location = locationManager.location?.coordinate else { return }
        let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        let chatroom = Chatroom(name: name, creatorUsername: creatorUsername, chatroomId: "", location: geoPoint)
        FirestoreHelper.addChatroom(chatroom: chatroom) { (error) in
            if error != nil {
                print("ADD CHATROOM ERROR: \(error!.localizedDescription)")
            }
            self.searchForNearbyChatrooms()
        }
    }
    
    func searchForNearbyChatrooms() {
        guard let location = locationManager.location?.coordinate else { return }
        refreshControl?.beginRefreshing()
        FirestoreHelper.getChatroomsNearBy(latitude: location.latitude, longitude: location.longitude, meters: proximityToChatroom) { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching nearby chatrooms: \(error!)")
                self.refreshControl?.endRefreshing()
                return
            }
            self.chatrooms.removeAll()
            for document in documents {
                if let chatroom = Chatroom(data: document.data()) {
                    self.chatrooms.append(chatroom)
                }
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatroomCell", for: indexPath) as! ChatroomTableViewCell

        cell.setChatroomToCell(chatroom: chatrooms[indexPath.row])

        return cell
    }
    
    var selectedChatroom: Chatroom?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChatroom = chatrooms[indexPath.row]
        performSegue(withIdentifier: "chatroomToChat", sender: nil)
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatroomToChat" {
            if let chatVC = segue.destination as? ChatViewController {
                chatVC.chatroom = selectedChatroom
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate and location permissions
    
    var previousLocation: CLLocation?
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
//            locationManager.distanceFilter = 5 // Is this needed? maby not?
            locationManager.startUpdatingLocation()
            previousLocation = locationManager.location
            searchForNearbyChatrooms()
            break
        case .denied:
            Alert.showBasicOkAlert(on: self, title: "Location services are denied", message: "Please turn on location services for this app to function correctly!")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            Alert.showBasicOkAlert(on: self, title: "Location services are restricted", message: "Please turn on location services for this app to function correctly!")
            break
        case .authorizedAlways:
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuth()
        } else {
            Alert.showBasicOkAlert(on: self, title: "Location services are unavailable", message: "Please turn on location services for this app to function correctly!")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let previous = previousLocation else { return }
        guard Double(locations.last!.distance(from: previous)) > 10.0 else { return }
        previousLocation = locations.last
        searchForNearbyChatrooms()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    

}
