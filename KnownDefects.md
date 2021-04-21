# Known Defects

## Endpoints
### Top Cities:
- using mock data for top cities, as no endpoint was available
### City Data:
- get_data endpoint from DS api is limited to certain citiies
- errors are handled such that walkability score is fetched (available for all cities) in the event that a searched city is not in the DS api
### Pinned Cities
- only local persistance is in place for pinned cities
- the Web api has an endpoint for saving pinned cities by user id, but the data currently stored there is not compatible with the DS api and the iOS app

## Settings/Livability:
- Settings page allows user to set thresholds for various data points in order to recalculate the livability score for each city, but this feature is not implemented with the api

## Top Cities Images:
- state flags are used as placeholder images for the Top Cities on the HomeScreen
