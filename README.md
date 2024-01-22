
# ArtApp
![artAppDemo2](https://github.com/dife97/BitsoCodingChallenge/assets/25800276/2820d122-b8ae-4809-a6ca-fbfdf7281b25)

## Features
- **Arts List:** View a list of arts.
- **Art Details:** Explore details of each art.

## Requirements
- **Pull to Refresh:** Easily update the arts list by pulling down.
- **Smooth Scrolling:** Prefetch next pages for a smooth scrolling experience.
- **Offline Access:** Access the Arts List even in offline mode.

## Assumptions and considerations
- I have assumed a pagination strategy with 10 items per page.
- Caching is implemented for the first page of the Arts List to optimize data storage on the user's device.
- Cached data is updated whenever the first page is fetched remotely, ensuring the most recent content is available for offline viewing.
- To enhance user experience, the app initially fetches text data for the Arts List, allowing users to view results quickly. Images are fetched subsequently.

## Modules
The project is structured into 4 main modules using native Xcode frameworks for simplicity and rapid development. All modules are decoupled using protocols, providing flexibility for future changes in modularization strategy.
![image](https://github.com/dife97/BitsoCodingChallenge/assets/25800276/6305614c-838e-4c86-ad4d-2304f3c31cd8)

Dependency diagram:
![ArtAppDependencyDiagram](https://github.com/dife97/BitsoCodingChallenge/assets/25800276/7e60c4bb-090c-4d07-a03d-0e3f8f0da9ce)

### ArtApp Module
This module encapsulates the domain logic, including rules for remote and caching operations. It implements three main features:
- **ArtsList:** Fetches the list of arts remotely and/or locally.
- **GetArtImage:** Fetches the image of each art remotely.
- **GetArtDetails:** Fetches details of a specific art remotely.

Test coverage is prioritized for this module as it forms the core of the application. Test performance is optimized by utilizing a macOS framework target.

### Main Module
Responsible for UI and presentation rules, including prefetching and refreshing. 
Utilizing the MVVM-C pattern with protocols over closure for improved testability and readability. 
I chose UIKit for UI components because of my proficiency and familiarity with this framework. 
The TableView setup follows the AbstractFactory pattern for easy implementation of pagination, prefetching, and state changes. 

Although ViewModel tests were not prioritized due to time constraints, they are recommended for future development. Snapshot tests have not been added.

### ArtStore Module
This module utilizes the FileManager for data storage, chosen for its simplicity. While CoreData was considered, FileManager aligns with the decision to cache only the first page and eliminates the need for a relational database. I've decoupled the implementation, ensuring flexibility for future enhancements by making it easy to integrate additional store providers when needed

### ArtNetwork Module
The service layer is implemented using URLSession with a simplified Moya approach. For now it supports only GET requests and interacts with two servers: the main Art API and an image IIIF-based API.

Due to time constraints, detailed unit tests for the ArtNetwork and ArtStore modules were not developed. My primary focus was on prioritizing the ArtApp module, given its critical role in the application's core functionality. Future iterations can include a more comprehensive testing suite for both modules

## Installation
After cloning this repository, open the `BitsoCodingChallenge.xcodeproj` file.

## Running the iOS App
To run the app, select the target Main and hit "Cmd + R" or click the play button in the left painel.
You will see some friendly log messages in the console while scrolling. 

![image](https://github.com/dife97/BitsoCodingChallenge/assets/25800276/7ec032fd-c6da-4165-961c-977ee2bad2d3)

## Running tests
To run the tests for the ArtApp module, select the "ArtApp" target and hit "Cmd + U". 

![image](https://github.com/dife97/BitsoCodingChallenge/assets/25800276/1e9b263f-561d-4a98-a93c-8c3da8002f60)
