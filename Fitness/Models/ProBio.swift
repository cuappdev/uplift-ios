//
//  ProBio.swift
//  Fitness
//
//  Created by Cameron Hamidi on 2/28/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation
import UIKit

struct ProBio {
    let id: String
    let name: String
    let profilePic: UIImage?
    let secondaryProfilePic: UIImage?
    let bio: String
    let links: [PersonalLinkObject]
    let expertise: [String]
    let routines: [ProRoutine]
    let summary: String
    
    init(id: String, name: String, profilePic: String, secondaryProfilePic: String, bio: String, links: [PersonalLinkObject], expertise: [String], routines: [ProRoutine], summary: String) {
        self.id = id
        self.name = name
        self.profilePic = UIImage(named: profilePic)
        self.secondaryProfilePic = UIImage(named: secondaryProfilePic)
        self.bio = bio
        self.links = links
        self.expertise = expertise
        self.routines = routines
        self.summary = summary
    }
    
    public static func getPro(name: String) -> ProBio {
        if name == "claire" {
            return getClaire()
        } else {
            return getClaire()
        }
    }
    
    public static func getClaire() -> ProBio {
        var urls: [PersonalLinkObject] = []
        urls.append(PersonalLinkObject(url: "www.instagram.com", site: .facebook))
        urls.append(PersonalLinkObject(url: "www.instagram.com", site: .instagram))
        urls.append(PersonalLinkObject(url: "www.linkedin.com", site: .linkedin))
        urls.append(PersonalLinkObject(url: "www.instagram.com", site: .other))
    
        let claireRoutine1 = ProRoutine(title: "Read a book for 10 mins", routineType: .mindfullness, text: "Do it in the morning and or before bed. Also don’t leave the house without your reading material and make sure to make use of your commuting times. Finally, find genres that interests you.")
        let claireRoutine2 = ProRoutine(title: "Play a sport for 30 mins", routineType: .cardio, text: "Do it in the morning and or before bed. Also don’t leave the house without your reading material and make sure to make use of your commuting times. Finally, find genres that interests you.")
        let claireRoutine3 = ProRoutine(title: "Plank for 5 mins", routineType: .strength, text: "Do it in the morning and or before bed. Also don’t leave the house without your reading material and make sure to make use of your commuting times. Finally, find genres that interests you.")
    
        let proClaire = ProBio(id: "test", name: "Claire Ng", profilePic: "testimage", secondaryProfilePic: "Combined Shape-1", bio: "Hi everyone! My name is Claire and some people know me as \"The Environmentalist Bodybuilder\". I'm currently a senior studying Marine Biology in the College of Agriculture and Life Sciences.", links: urls, expertise: ["Meditation", "Healthy Eating", "Cutting"], routines: [claireRoutine1, claireRoutine2, claireRoutine3], summary: "Meditation & eating healthy")
        
        return proClaire
    }
}
