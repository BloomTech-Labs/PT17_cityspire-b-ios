# Known Defects

## Search
### UI:
- UI constraints don't autosize for larger devices.
### Code:
- Known errors with the user's search. More error handling needed here to prevent incorrect user input/format.
- Does not pull all data that is accessible from the api due to incorrect JSON formatting.

## Map
### UI:
- Favorite icon does not toggle colors if favorited/unfavorited.
- Does not display all data we created buttons/icons for.
### Code:
- Did not implement callout views on the annotations for the mapview.

## Login
### UI:
-Okta sign in redirects user to safari instead of staying in the app to complete sign in.
### Code:
- New user can't create an account with Okta

## Favorites
### UI:
- There are placeholder labels in the cells for use with important data pulled from JSON that we were unable to attain.
### Code:
- Cells from CollectionView are unclickable. Does not segue to map viewcontroller.

[Video Overview](https://www.loom.com/share/44386b011fc34f599ae2d15e49a561e1)
