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

## Feature 7 - Distance

Let's add a new plugin named geolocator.
As before, visit https://pub.dev/packages/geolocator and folllow the readme to add it to the app. Don't forget the platform part !

Now, add the distance feature to your app.
To make it, use the `distanceBetween` method of the Geolocator plugin.

Add a new text in the Starting position sub-page that contains `actually at XXX meters from this point`
Add a new text in the Actual position sub-page that contains `actually at XXX meters from the starting point`

## Feature 8 - Boundary setting

Change the code of the settings sub-page and add it an app setting named `boundary`. This setting is a number expressed in meters.
The user should be able to type it in the settings sub-page.
You have to save it somewhere in the app.
Log the new value in the console each time the user change this setting.

Important: No validation button is allowed. The user should be able to change this setting without any other screen or dialog.

## Feature 9 - Alert setting

Add a new setting named `enable alerts` in the settings sub-page. This setting is a boolean.
The user should be able to activate it whenever he wants via a toggle button.
You have to save it somewhere in the app.
Log the new value in the console each time the user change this setting.

## Feature 10 - Out of bounds tracking

When the user enables alerts, start to track the location changes with the `location` plugin.
Each change should update the distance from the starting point.
If the new distance from the starting point is greater than the `boundary`setting, the user is considerred as out of bounds. 
When the user goes out of the bounds log it in the console.

At the end of this exercice, a new message should appear in the console log when the user is out of bounds `only if the alerts are enabled`.

## Feature 11 - Notification

Visit https://pub.dev/packages/flutter_local_notifications and follow the readme to add it to your app.

Open a notification when the user enables the alerts via the `enable alerts` setting. 
The text should be `Alerts enabled` and the title should be the name of the app.
This notification should NOT be cancellable.
This notificaiton should disappear when the user disables the alerts.

Open a second notification when the user goes out of bounds.
The text should be `Alert ! You are XXX meter too far from your starting point` and the title should be the name of the app.
This notification should be cancellable
This notification should be updated with the text `Ok, all is all right now.` when the user comes back inside the bounds.