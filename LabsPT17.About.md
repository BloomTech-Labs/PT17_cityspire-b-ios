# About this App
### from LabsPT17 - [Cora Jacobson](https://github.com/CoraJacobson) and [Kevin Stewart](https://github.com/Kstu24)

## Links

[Trello Board](https://trello.com/b/lHklvNAt/labspt17-cityspire-b)
[Whimsical](https://whimsical.com/cityspire-b-6b24Bc6MfwKCypGWjXF2XT)
[DS API Documentation](http://cityspire-b-ds.eba-jesgmne9.us-east-1.elasticbeanstalk.com/#/)

## Okta Authentication

As a Lambda Labs project, we were required to use Okta Auth as third party authentication. This was already set up for us, and as far as we know, it was also provided to the previous cohort. When the user taps the Sign In button on the LoginVC, they are taken to Safari to enter a username and password. Upon successfully signing in, they are automatically taken back to the iOS app.

Okta Auth is configured in the the ProfileController using the following code:

```
let oktaAuth = OktaAuth(baseURL: URL(string: "https://auth.lambdalabs.dev/")!, clientID: "0oa18is3355KlyP5C4x7", redirectURI: "labs://cityspire/implicit/callback")
```

The clientID is specific to the CitySpire project, and should not need to change.

The baseURL in the ProfileController ("https://pt17-cityspire-b.herokuapp.com/") is used to fetch profile information after authentication succeeds. This url is the Web back end, and should be changed to the current cohort's url, as the pt17 api will be shut down at some point during the next cohort.

Here is the [documentation](https://docs.labs.lambdaschool.com/guides/okta/okta-basics) for Okta Auth, which provides the usernames and passwords for the eight Test Users in the system.

## Navigation

Due to the way that the LoginVC was set up, the rest of the app is being presented modally, and we were unable to effectively use a navigation controller or tab bar controller with this configuration. We created a "Mock Tab Bar" to handle this, and improve the navigation for the app.

Another approach could be to restructure the app so that the LoginVC presents modally on top of the HomeScreenVC, and is dismissed upon successful sign in. We did not implement this because we were advised to avoid any unnecessary refactoring.

## Settings Screen

The Settings Screen was our idea for how to collect thresholds from the user in order to recalculate the livability scores based on the user's preferences. The Livability endpoint that exists in the DS api was created prior to our Labs unit, and did not have sufficient documentation for us to use it. At this time, the settings are able to be saved in User Defaults, but they are not used in any algorithm to modify livability scores.

## Networking & Mock Data

### Mock Data

The app contains a MockLoader and mock data, which we used to configure our data models and UI prior to the implementation of the DS api. The ApiController is set up to be able to switch between mock data and api endpoints with relative ease. The mock data for Top Cities is still in use, as that endpoint was not completed, so the fetchTopCities method contains example code for using the mock loader.

### Favorites Endpoint - from Web

The Web team set up an endpoint with the idea that we would be able to sync a user's Pinned Cities cross-platform. This endpoint was not available until the end of Labs, and no documentation was provided to us. Also, the data currently saved for User1's favorites is not compatible with the DS api or our app.

- One of the city names is not capitalized
- The state names are spelled out instead of using the two-letter abbreviation
- The words used for the "crime" and "air_quality_index" keys are not part of the agreed-upon list of words
- The coordinates do not have enough decimal places

Therefore, we chose not to implement this endpoint at this time.

### Jobs & School District Endpoints - from DS

These endpoints were added at the very end of our Labs unit, and we did not use them in the iOS app.
