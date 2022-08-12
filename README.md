# MusicBuddy Capstone - Project Spec

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)

## Overview
### Description
MusicBuddy is a social music app that allows users to network with others and explore new music. Users can listen to music through the app and discover new artists (generated based on the users' top artists' related artists). Users can view their top 20 songs and artists on their profile and refresh this data. There is a live forum where users can meet new people and discuss their favorite music and get new music suggestions. Users can also see how compatible their music taste is with other users by seeing their percentage match compatibility and view other users' top 20 songs and artists.

### App Evaluation
- **Category:** Social Networking / Music
- **Mobile:** This app would be primarily developed for mobile. 
- **Story:** The app analyzes users' music taste, and connects them to other users with similar choices. Users can see how compatible their music taste is with other users.
- **Market:** Anyone could use this app. 
- **Habit:** This app could be used as often as the user wanted depending on how what they're looking for (song recommendations, new friends, etc.).
- **Scope:** First, we would start with displaying the user's top data. Then we would work on displaying and fetching other users' top data. Using these two sets of data, we could then generate a % match compatability.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can message on a live forum
* User can see favorite artists/songs
* Users can see other app users 
* Users can see % similarity with other users
* Users can see other users top data

**Optional Nice-to-have Stories**
* Page where user can just listen to their own music
* Users can get artist recommendations based on their top artists
* Persisted user can refresh their top data 

### 2. Screen Archetypes

* Login 
* Register - User signs up or logs into their account
* Matches Screen - Other users displayed
* Matches Details Screen - Percentage similarity displayed, other users' top data displayed
* Messages Screen - Live forum for users to communicate
* Profile Screen - User can upload a photo and see top artist/song info
* Music Screen - User can play, pause, skip, skip to prev song

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile
* Music
* Messages
* Matches

**Flow Navigation** (Screen to Screen)
* Forced Log-in -> Account creation if no log in is available
* Music Selection -> Jumps to Chat
* Profile -> Text field to be modified. 
* Settings -> Toggle settings
