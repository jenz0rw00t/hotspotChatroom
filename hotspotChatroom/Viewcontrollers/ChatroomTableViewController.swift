//
//  ChatroomTableViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-12.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreLocation

class ChatroomTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var chatrooms = [Chatroom]()
    var currentUser: User?
    let locationManager = CLLocationManager()
    let proximityToChatroom: Double = 20 // How close in meters you need to be able to join a chatroom

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        getCurrentUser()
        checkLocationServices()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        createChatroomAlert()
    }
    
    // MARK: - Functions
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Searching for nearby chatrooms...")
        refreshControl?.addTarget(self, action: #selector(dragDownUpdate) , for: .valueChanged)
    }
    
    @objc func dragDownUpdate() {
        searchForNearbyChatrooms()
    }
    
    func getCurrentUser() {
        guard let userId = LogInHelper.getCurrentUserID() else { return }
        FirestoreHelper.getUser(userId: userId) { (snapshot, error) in
            if error != nil {
                print("GET USER ERROR: \(error!.localizedDescription)")
                return
            }
            guard let snap = snapshot else { return }
            guard let data = snap.data() else { return }
            let user = User(data: data)
            self.currentUser = user
        }
    }
    
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
        FirestoreHelper.addChatroom(name: name, creatorUsername: creatorUsername, location: geoPoint) { (error) in
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
    
    // MARK: - viewWillAppear signed in listener
    
    var listener: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener = LogInHelper.signedInListener { (auth, user) in
            if user == nil {
                self.tabBarController!.performSegue(withIdentifier: "signInSegue", sender: nil)
            } else if user?.uid != LogInHelper.getCurrentUserID() {
                self.currentUser = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogInHelper.removeSignInListener(listener: listener!)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chatroomToChat", sender: nil)
    }
    
    // Mark: - CLLocationManagerDelegate and location permissions
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.distanceFilter = 10 // Is this needed? maby not?
            locationManager.startUpdatingLocation()
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
        searchForNearbyChatrooms()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    

}
