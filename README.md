# OutOfBounds

Tranning application created to explore Flutter recipies.

## Goal of the app

Locate the user and notifiy him when he goes out of the bound that he specified before.

## Participation

Each participant must create a branch named as follow :

feat/<FEATURE_NAME>

## Feature 1 - Hello world

Change your main page to make it openable.
This page should show a welcome message in the center.

## Feature 2 - Navigation bar

Add a bottom navigation to your main page.
The bottom bar should contain 3 items :
    - Start position (left)
    - Actual position (center)
    - Settings (right)

Each item should be represented by an Icon and a text

## Feature 3 - Interraction

Add some life to you app !
When you click on each item of the bottom bar a new sub-page should appear INSIDE your main page.
For the moment, each sub-page should just contain a Color.
Let's choose :
    - Starting position sub-page should be blue
    - Actual position should be red
    - Settings sub-page should be green

## Feature 4 - Add a plugin

To know where the user is, we have to use a flutter plugin !
Visit https://pub.dev/packages/location and follow the readme :
    - add this plugin to your pubspec.yaml
    - do the setup for each platform (Android & IOS)

## Feature 5 - Actual position

Now you are able to locate the app's user.
Change the code of the actual position sub-page to make it implement the newly added plugin "location".
To make it you will have to follow the readme of the plugin.

At the end of this exercice the app should :
    - ask the permission to use the location of the user
    - show the actual position of the user in the center sub-page

Nb: For the moment, just show the longitude and latitude.

## Feature 6 - Starting position

On the Actual position sub-page, add a button named "Make as start" that save the current position to make it the starting position.

At the end of this exercice the first sub-page should show the last saved position.