## TicketingHub

This is the repository for the iPad app.

The connection to the TicketingHub API is provided by the ios-api library which
is a pod. The app uses Core Data, but the model is provided by the ios-api
library and is already part of the repository, as are the custom NSManagedObject
classes that are used as part of this.

## Installation

A simple git clone will do. Then from project directory just run.

    pod install

which will install all dependencies including ios-api project, which Podspec is included in the mani directory.
If no cocoapods installed go to http://cocoapods.org for further informations.

## Updating

### Notes

