## TicketingHub

### Notes

#### Core Data

This uses [mogenerator](https://github.com/rentzsch/mogenerator). Not part of
the project, but will need to be installed on the machine if changes are made to
the model.

After any changes to the model, run the `cd_generate` script in the root of the
project to update the Machine generated files.

DCTCoreDataStack is added as a submodule for handling the Core Data Stack

#### sort-xcode-project-file

This is a convenience script that sorts the files in the Xcode project. Useful
if there are merge conflicts at the project level between branches. It doesn't
need to be used every time, and you may need to re-arrange the groups in the
project after successfully merging.
