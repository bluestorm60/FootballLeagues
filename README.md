# Football-Leagues iOS App

## About

The project is a simple mobile application designed to display football team data, games, and their results.

### Requirements

- iOS 14.0+
- Xcode 14.3

### Setup

- Clone the repository to your local machine.
- Open the project in Xcode.

### Technical Requirements

- Implement the business logic and screen/view flow as outlined in the objective section.
- Ensure the application is aesthetically appealing with only three main screens.
- Utilize Clean Architecture along with MVVM-C for the presentation layer:
  - The view should retrieve persisted data from Core Data if it is avaliable, else from web API.
  - The second view should asynchronously update data from the web API.
- Use manual dependency injection with dependency containers.
- Store data using Core Data.
- Handle networking using URLSession and decode JSON data using Codable.

### Architecture
- MVVM-C

#### Model:
Represents the data and business logic of the application. It's responsible for retrieving, storing, and processing data.

#### View:
This is what's presented to the users - the user interface. It displays the data provided by the ViewModel.

#### ViewModel:
Acts as a bridge between the Model and the View. It holds the presentational logic and prepares data to be displayed by the View. Any user interaction in the View is forwarded to the ViewModel.

#### Coordinator:
An additional layer to handle the navigation logic. Instead of having view controllers know about each other and how to navigate, Coordinators encapsulate this logic ensuring a cleaner and more reusable approach.

By employing MVVM-C, the Football-Leagues iOS App ensures a clear separation of concerns, which in turn aids in writing clean, organized, and testable code.

### Structure 
- "Application": Which contains AppDelegate, SceneDelegate, MainStoryboard and LaunchScreen Storyboard.
- "Network" : This layer is dedicated to establishing and managing network connections, leveraging URLSession for API calls and data retrieval.
- "Coordinators": Contains the Coordinator protocol, which outlines the contract for coordinator classes. Coordinators are used to manage the application's navigation logic, ensuring a decoupled and modular approach.
- "Resources" : Houses essential files such as property list (.plist) configurations, database files, and asset catalogs.
- "Utilites" : A comprehensive collection of shared tools and resources.

### Testing 
- The application boasts a test coverage exceeding 70% (business logic, use cases, repositories, and view models).

### Dependencies:
- [Netfox](https://github.com/kasketis/netfox): Netfox provides a quick look on all executed network requests.
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage) : AlamofireImage is an image component library for Alamofire.

### Known issues:
- The primary API is invoked to fetch a list of competitions. Each competition item retrieved has a unique identifier known as the competition Code. Subsequently, for every individual competition Code, two separate API calls are made: one to retrieve the number of teams and another to obtain the count of games associated with that specific competition. Notably, After excuting multi requests at the same time, Apis return the following response "must wait couple of second" before calling the next api.(Solution: Make delay before calling the next Api). So i could not get the teams and matches count.
- CoreDataRepo testing coverage is 20 % only.

### Api URLs
- https://api.football-data.org/v4/competitions 
- https://api.football-data.org/v4/competitions/{COMPETITION_CODE}/teams 
- https://api.football-data.org/v4/competitions/{COMPETITION_CODE}/matches
- https://api.football-data.org/v4/teams/{TEAM_ID}/matches
