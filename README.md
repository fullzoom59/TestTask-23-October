# City Bike Stations App

### Location Permissions

- The app requests location permissions on launch once.
- The app acquires the current location of the user.
  - For simulation, set location to Vienna: Latitude `48.210033`, Longitude `16.363449`

### API Access

- The app uses the API endpoint: `https://api.citybik.es/v2/networks/wienmobil-rad`
- [API Documentation](https://api.citybik.es/v2/)

#### Bike Stations List

- The list of bike stations is displayed.
- Sorting:
  - By name, if no location has been acquired.
  - By distance to current location if location has been acquired, closest first.

#### List Item

- Each item displays:
  - Station Name
  - Number of bikes available
  - Number of empty slots available

### Navigation

- Tapping an item in the list opens: `http://maps.apple.com/?l=LATITUDE,LONGITUDE` 


| Feature | Preview |
| --- | --- |
| **Location Alert** <br/>At the first startup we get an alert asking for a location | ![Location Alert](https://github.com/fullzoom59/TestTask-23-October/assets/119012478/dbb4150c-698b-4346-b17e-402df65a2b45)
| **Location resolution** <br/>If the user has allowed geolocation, we sort the array to the closest locations | ![Location resulution](https://github.com/fullzoom59/TestTask-23-October/assets/119012478/2084303f-a9ff-48da-b3b4-73e6cd9e9f6b) |
| **Locking the location** <br/>If the user has disallowed the use of geolocation, we sort the array alphabetically  |![Locking the location](https://github.com/fullzoom59/TestTask-23-October/assets/119012478/ae1b6066-621c-4b83-92d9-4e68f7b0483a)
