//
//  ProBio.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/28/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

struct ProBio {
    let bio: String
    let expertise: [String]
    let id: String
    let links: [PersonalLink]
    let name: String
    let profilePic: UIImage?
    let routines: [ProRoutine]
    let secondaryProfilePic: UIImage?
    let summary: String

    init(id: String, name: String, profilePic: String, secondaryProfilePic: String, bio: String, links: [PersonalLink], expertise: [String], routines: [ProRoutine], summary: String) {
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

    public static func getAllPros() -> [ProBio] {
        return [getClarie(), getJuan(), getMadeline(), getStarks(), getCleo()]
    }

    public static func getClarie() -> ProBio {
        var urls: [PersonalLink] = []
        urls.append(PersonalLink(url: URL(string: "https://www.instagram.com/thenvironmentalistbodybuilder/"), site: .instagram))
        let routine1 = ProRoutine(title: "Read a book for 10 mins", routineType: .mindfulness, text: "Do it in the morning and/or before bed. Also don’t leave the house without your reading material and make sure to make use of your commuting times. Finally, find genres that interests you.")
        let routine2 = ProRoutine(title: "Go for a run", routineType: .cardio, text: "Start out with small, achievable goals. Start by running up to a mile at a time every time you run, and don’t increase by more than a mile each week. Listen to your body, get the right shoes, and make sure someone checks your form!")
        let routine3 = ProRoutine(title: "Lift weights for 30 mins", routineType: .strength, text: "First of all, form is EVERYTHING. Work with someone who can spot you for the movements as you start. Muscle fatigue each time is not desired, so start by doing small rep/low weight circuits of simple movements (back squats, presses, deadlifts) 3x a week, increasing weight 5-10lbs each week.")
        let proClarie = ProBio(id: "test", name: "Clarie Ng", profilePic: "claire", secondaryProfilePic: "claireSecondary", bio: "Hi everyone! My name is Clarie and some people know me as \"The Environmentalist Bodybuilder\". I'm currently a senior studying Marine Biology in the College of Agriculture and Life Sciences.", links: urls, expertise: ["Meditation", "Healthy Eating", "Cutting"], routines: [routine1, routine2, routine3], summary: "Meditation & eating healthy")
        return proClarie
    }

    public static func getJuan() -> ProBio {
        var urls: [PersonalLink] = []
        urls.append(PersonalLink(url: URL(string: "https://www.instagram.com/jv_gar1012/"), site: .instagram))
        urls.append(PersonalLink(url: URL(string: "https://www.facebook.com/profile.php?id=100010308969934"), site: .facebook))
        let routine1 = ProRoutine(title: "Relax", routineType: .mindfulness, text: "I’d recommend either reading a book for 10 min a day or going on a walk for 10-15 without music playing.")
        let routine2 = ProRoutine(title: "Go for a run", routineType: .cardio, text: "If you’re going for distance, start off at a distance that you are comfortable with (i.e. 1 mile) and add .25-.5 miles to it with every week that you go to challenge yourself to reach your hidden potential. On the other hand, if you’re going for speed, do short bursts (10-20 seconds) of sprinting on the treadmill followed by 45 seconds to a minute of rest and repeat 8-10 times.")
        let routine3 = ProRoutine(title: "Weightlifting", routineType: .strength, text: "Know what your one rep max is for compound movements which include Bench Press, Squats, and Deadlifts to name a few. From there, begin performing these movements ranging from 3 reps to 5 reps for 3 to 5 sets with a weight that is 70-75% of your one rep max. In addition, work on accessories that are needed for each compound movement (i.e. Chest, shoulders and triceps for Bench Press). Never do the same exercises when you go to the gym, best thing for muscle growth/strength is shocking your muscles with different routines or training methods. For example, one training method that I like to do is dropsetting, which consists of starting at a particular weight and performing reps with it until failure, followed by dropping the weight by 5-10 pounds and repeating this cycle of reaching failure until you get to a weight that stops challenging you.")
        let proJuan = ProBio(id: "test", name: "Juan Garcia", profilePic: "juan", secondaryProfilePic: "juanSecondary", bio: "My name is Juan Garcia and I’m a junior studying Operations Research and Information Engineering with a minor in Business. I’m from Edinburg, Texas which is a border town alongside the Rio Grande River which separates Texas and Mexico. I began my lifting career the summer after high school when I was here at Cornell participating in the Prefreshman Summer Program.(shoutout to my 2016 PSP class!) Outside of classes and lifting, I enjoy playing a variety of sports, more importantly basketball, hiking when it’s a beautiful day outside, playing video games, and collaborating with others on ideas that can potentially make positive impacts on communities.", links: urls, expertise: ["Weightlifting"], routines: [routine1, routine2, routine3], summary: "Weightlifting and strength training")
        return proJuan
    }

    public static func getMadeline() -> ProBio {
        var urls: [PersonalLink] = []
        urls.append(PersonalLink(url: URL(string: "https://www.instagram.com/trainwithmadeline/"), site: .instagram))
        let routine1 = ProRoutine(title: "Make time for yourself", routineType: .mindfulness, text: "Give yourself 30 minutes a day to do something that makes you happy. I wake up earlier than I need to every morning for an oat milk latte and 30 minutes to lightly stretch and go through my Instagram feed--just to have some time to myself!")
        let routine2 = ProRoutine(title: "Enroll in a fitness class", routineType: .cardio, text: "You're already probably getting your steps in without even realizing it (you can thank all the Cornell hills for that!). So to step it up a notch I'd recommend a group fitness class like Spinning for beginners so they can increase their cardio performance with some guidance!")
        let routine3 = ProRoutine(title: "Start small", routineType: .strength, text: "Start small, stay consistent and pick something you actually like! My advice would be to pick a skill that you'd like to improve and incorporate it consistently at the end of your workouts or throughout the day. When I first started out I really wanted to get better at pushups so I always ended my workouts with 10 pushups, now it's part of my warm up instead!")
        let proMadeline = ProBio(id: "test", name: "Madeline Ugarte", profilePic: "madeline", secondaryProfilePic: "madelineSecondary", bio: "I’m a National Academy of Sports Medicine Certified Personal Trainer and Performance Enhancement Specialist (NASM-CPT, PES), and I’m a certified instructor in Spinning, SpinPower, TRX, Power HIIT and Shockwave. Other than that, I’m a proud Chicago native and a senior at Cornell. Can't wait to see you in a class!", links: urls, expertise: ["Spinning", "Weightlifting", "Strength", "Conditioning"], routines: [routine1, routine2, routine3], summary: "Strength and Conditioning")
        return proMadeline
    }

    public static func getStarks() -> ProBio {
        var urls: [PersonalLink] = []
        urls.append(PersonalLink(url: URL(string: "https://www.instagram.com/starkstwins/"), site: .instagram))
        let routine1 = ProRoutine(title: "Make time for yourself", routineType: .mindfulness, text: "Take time for yourself everyday. It is important to relax your mind and brain and do something you enjoy, even if it is just for 20 minutes a day.")
        let routine2 = ProRoutine(title: "Walk to class everyday", routineType: .cardio, text: "Unless it's sub-zero outside, walking to class on a campus like Cornell will get thousands of steps per day. Plus, with all of the slopes and hills, you are bound to get an effective cardio workout everyday.")
        let routine3 = ProRoutine(title: "Go to the gym", routineType: .strength, text: "Go to the gym, and go consistently. Even if you plan to go twice per week, it is important to establish the routine. Going consistently is what will get you to your goals.")
        let proStarks = ProBio(id: "test", name: "Austin and Justin Starks", profilePic: "starks", secondaryProfilePic: "starksSecondary", bio: "We're twin powerbuilders: people who lift to get stronger and look better. As students, we're computational biology majors who intend to attend graduate school in bioinformatics, computational biology, or computer science.", links: urls, expertise: ["Powerlifting", "BodyBuilding"], routines: [routine1, routine2, routine3], summary: "Strength and Resistance Training")
        return proStarks
    }

    public static func getCleo() -> ProBio {
        var urls: [PersonalLink] = []
        urls.append(PersonalLink(url: URL(string: "https://instagram.com/fitnessbycleo"), site: .instagram))
        let routine1 = ProRoutine(title: "Relax and reflect", routineType: .mindfulness, text: "I am an avid knitter and I do yoga regularly. Find something that relaxes you that isn’t physically taxing and turn it into a habit! Additionally, take time to reflect at the beginning or end of each day, actively watching thoughts pass through your head without dwelling on them.")
        let routine2 = ProRoutine(title: "Go for a run", routineType: .cardio, text: "Start out with small, achievable goals. Start by running up to a mile at a time every time you run, and don’t increase by more than a mile each week. Listen to your body, get the right shoes, and make sure someone checks your form!")
        let routine3 = ProRoutine(title: "Weightlifting", routineType: .strength, text: "First of all, form is EVERYTHING. Work with someone who can spot you for the movements as you start. Muscle fatigue each time is not desired, so start by doing small rep/low weight circuits of simple movements (back squats, presses, deadlifts) 3x a week, increasing weight 5-10lbs each week.")
        let proCleo = ProBio(id: "test", name: "Cleo Kyriakides", profilePic: "cleo", secondaryProfilePic: "cleoSecondary", bio: "I’m a long distance runner who got hooked onto CrossFit along the way! I love feeling strong and sharing my knowledge to help people reach their goals. I’m also the 2018-19 Fitness Club prez and a member of Track Club!", links: urls, expertise: ["Running", "Olympic lifting", "CrossFit"], routines: [routine1, routine2, routine3], summary: "Resistance Training and Cardio")
        return proCleo
    }

    public static func getMark() -> ProBio {
        var urls: [PersonalLink] = []
        urls.append(PersonalLink(url: URL(string: "https://www.facebook.com/mark.rittiboon"), site: .facebook))
        let routine1 = ProRoutine(title: "Cook", routineType: .mindfulness, text: "I love to cook! Nothing like Spotify's \"cooking music\" playlist and eggs in the morning :)")
        let routine2 = ProRoutine(title: "Go for a swim", routineType: .cardio, text: "I don't enjoy running and Ithaca is really cold so I don't do it haha... I find swimming to be really fun and effective. For me, it's also the best form of active recovery!")
        let routine3 = ProRoutine(title: "Weightlifting", routineType: .strength, text: "I think everyone looking to build strength should focus on compound lifts (Squats, Deadlifts, Bench, etc). A 5x5 beginner program is a good start!")
        let proMark = ProBio(id: "test", name: "Cleo Kyriakides", profilePic: "mark", secondaryProfilePic: "markSecondary", bio: "I used to be a competitive strength athlete participating in powerlifting and strongman competitions. However, I've transitioned into combat sports ~ recently completing a fighting camp in Phuket, Thailand!", links: urls, expertise: ["Weightlifting"], routines: [routine1, routine2, routine3], summary: "Weightlifting and Combat Sports")
        return proMark
    }

}
