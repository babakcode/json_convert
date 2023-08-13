

### json_convert  👋
Generate codes for freezed, json_serializable, classic models easily

## Features

> dart run json_convert
> dart run json_convert build
> dart run json_convert clear

## Getting started

Add some json file inside `assets/`  folder

<img src="https://assets.babakcode.com/flutter/packages/json_convert/json_convert03_edited.jpg" width="300"
alt="babakcode.com">

assets/json_convert/`user.json`

```json
{  
  "name" : "Babak",  
  "nicName": "BabakCode",  
  "website": "http://babakcode.com",  
  "age": 23,  
  "location": {  
    "lat": 34.12,  
    "lng": 46.22341  
  },  
  "posts": [  
    {  
      "name": "Get datatype in dart",  
      "description": "Use `is` to identify the data type"  
    },  
    {  
      "name": "show image in flutter",  
      "description": "Use Image.asset to load images from asset folder"  
    }  
  ]  
}
```

and for assets/json_convert/`city.json`

```json
{  
  "name": "San Diego",  
  "population": 3500000,  
  "populationStr": "3.5mil",  
  "country": {  
    "_id": 23,  
    "name": "USA"  
  }  
}
```


or you can add them in your desired location with this configuration 👇

## Usage

=== "Tab 1"  
Markdown **content**.

Multiple paragraphs.  
=== "Tab 2"  
More Markdown **content**.

- list item a - list item b
## Additional information

TODO: Tell users more about the package: where to find more information, how to  
contribute to the package, how to file issues, what response they can expect  
from the package authors, and more.