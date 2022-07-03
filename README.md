# Social-Music Capstone - Project Spec

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)

## Overview
### Description
A social music app where users enter their favorite songs and artists and are shown other users with a % of music taste similarity. Users can create playlist blends with other users that combines their music tastes. They can message other users to give/receive song recommendations. Users set their platform preference for listening to songs. The app then converts songs from one platform to the preferred platform when shared (example: User uses Spotify, converts received message from Apple Music to Spotify). 

### App Evaluation
- **Category:** Social Networking / Music
- **Mobile:** This app would be primarily developed for mobile. Functionality wouldn't be limited to mobile devices, but the mobile version could have more features.
- **Story:** The app analyzes users' music taste, and connects them to other users with similar choices. When messaging users, the app will convert the platform the song is going to play on to the user's preferred platform.
- **Market:** Anyone could use this app. 
- **Habit:** This app could be used as often or unoften as the user wanted depending on how what they're looking for (song recommendations, new friends, etc.).
- **Scope:** First we would start with pairing people based on music taste and blending their songs into joint playlists. Then we would implement the platform conversion aspect in messaging. Large potential for use with spotify, apple music, or other music streaming applications.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User logs in to access previous chats and preference settings
* User picks favorite artists/genres/songs
* Users can see a list of profiles with the % of similarity, can click on them to message them
* Profile pages for each user
* Settings (Accesibility, Notification, General, etc.)

**Optional Nice-to-have Stories**

* Page of most played songs (i.e. songs that most users are connecting through)
* Page of most played blends, top user pairings
* Ability to create multiple different blends with the same user
* Page where user can just listen to their own music and get recommendations based off of their past listening activity

### 2. Screen Archetypes

* Login 
* Register - User signs up or logs into their account
   * Upon Download/Reopening of the application, the user is must log in to access profile information to be properly matched with another person. 
* Matches Screen - Chat for users to communicate (direct 1-on-1)
   * Upon selecting music choice, users can see different matches and option to message them
* Messages Screen - Chat for users to communicate (direct 1-on-1)
    * Users can converse with one another
* Profile Screen 
   * User can upload a photo and fill in general information
* Song Selection Screen
   * User can choose a desired song, artist, genre, or playlist and start listening and interacting with others.
* Settings Screen
   * Can change language, and app notification settings.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile
* Settings

Optional:
* Discover (Top Choices)

**Flow Navigation** (Screen to Screen)
* Forced Log-in -> Account creation if no log in is available
* Music Selection (Or Queue if Optional) -> Jumps to Chat
* Profile -> Text field to be modified. 
* Settings -> Toggle settings
