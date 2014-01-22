## TicketingHub

This is the repository for the iPad app.

The connection to the TicketingHub API is provided by the ios-api library which
is a submodule. The app uses Core Data, but the model is provided by the ios-api
library and is already part of the repository, as are the custom NSManagedObject
classes that are used as part of this.

## Installation

A simple git clone will do. To make life simpler it can be cloned in one stop
from the command line with

    git clone --recursive git@github.com:ticketinghub/ipad.git

which will clone and recursively clone the submodules.

## Updating

After cloning the app and getting the code running locally, you'll need to
update to the latest code base from time to time. This is easily done.

Firstly - update the code from git:

    git pull origin master

If you haven't made any local changes to the code, then this should cause no
problems.

Secondly - update the dependencies

    git submodule update --recursive

And this should update any external code to their required versions

### Notes

#### sort-xcode-project-file

This is a convenience script that sorts the files in the Xcode project. Useful
if there are merge conflicts at the project level between branches. It doesn't
need to be used every time, and you may need to re-arrange the groups in the
project after successfully merging.
