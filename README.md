@@ -60,11 +60,11 @@ Given the customer doesn't have connectivity
 - URL

 #### Primary course (happy path):
 1. Execute "Load Feed Items" command with above data.
 1. Execute "Load Image Feed" command with above data.
 2. System downloads data from the URL.
 3. System validates downloaded data.
 4. System creates feed items from valid data.
 5. System delivers feed items.
 4. System creates image feed from valid data.
 5. System delivers image feed.

 #### Invalid data – error course (sad path):
 1. System delivers invalid data error.
 @@ -76,32 +76,32 @@ Given the customer doesn't have connectivity
 ### Load Feed From Cache Use Case

 #### Primary course:
 1. Execute "Load Feed Items" command with above data.
 1. Execute "Load Image Feed" command with above data.
 2. System fetches feed data from cache.
 3. System validates cache is less than seven days old.
 4. System creates feed items from cached data.
 5. System delivers feed items.
 4. System creates image feed from cached data.
 5. System delivers image feed.

 #### Error course (sad path):
 1. System delivers error.

 #### Expired cache course (sad path): 
 1. System deletes cache.
 2. System delivers no feed items.
 2. System delivers no feed images.

 #### Empty cache course (sad path): 
 1. System delivers no feed items.
 1. System delivers no feed images.


 ### Cache Feed Use Case

 #### Data:
 - Feed items
 - Image Feed

 #### Primary course (happy path):
 1. Execute "Save Feed Items" command with above data.
 1. Execute "Save Image Feed" command with above data.
 2. System deletes old cache data.
 3. System encodes feed items.
 3. System encodes image feed.
 4. System timestamps the new cache.
 5. System saves new cache data.
 6. System delivers success message.
 @@ -123,14 +123,14 @@ Given the customer doesn't have connectivity

 ## Model Specs

 ### Feed Item
 ### Feed Image

 | Property      | Type                |
 |---------------|---------------------|
 | `id`          | `UUID`              |
 | `description` | `String` (optional) |
 | `location`    | `String` (optional) |
 | `imageURL`    | `URL`               |
 | `url`            | `URL`               |

 ### Payload contract

```
GET *url* (TBD)
200 RESPONSE
{
    "items": [
        {
            "id": "a UUID",
            "description": "a description",
            "location": "a location",
            "image": "https://a-image.url",
        },
        {
            "id": "another UUID",
            "description": "another description",
            "image": "https://another-image.url"
        },
        {
            "id": "even another UUID",
            "location": "even another location",
            "image": "https://even-another-image.url"
        },
        {
            "id": "yet another UUID",
            "image": "https://yet-another-image.url"
        }
        ...
    ]
}
```
