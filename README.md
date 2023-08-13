

### json_convert  👋
Generate codes for freezed, json_serializable, classic models easily

## Features

To convert json files to dart files, Use:

**`dart run json_convert`**

To build *`file.g.dart`* or *`file.freezed.dart`* with [*build_runner*](https://pub.dev/packages/build_runner), use following command:

**`dart run json_convert build`**

To clear generated configuration file of json_convert with your needs, run following command:

**`dart run json_convert clear`**

## Getting started

Add some json file inside `assets/` folder

<img src="https://assets.babakcode.com/flutter/packages/json_convert/json_convert03_edited.jpg" width="300"
alt="https://babakcode.com">

assets/json_convert/`user.json`

```json
{
   "name" : "Babak",
   "nickname": "BabakCode",
   "websiteAddress": "http://babakcode.com",
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


or you can add them at your desired location with the `Additional information` configuration 👇

## Usage

Run following command to generate dart files:

`dart run json_convert`

![dart run json_convert](https://assets.babakcode.com/flutter/packages/json_convert/export.gif)

And now you can see exported dart files in `lib/models` folder:
![json_convert exported dart files](https://assets.babakcode.com/flutter/packages/json_convert/json_convert04.png)

## Additional information
Json_convert will ask you some questions.

1. Select json files directory.

```cmd
  Default json files directory is: `assets/json_models`
  Would you like to change directory?
  [Press Enter / Write new dir location]:
```
You can press Enter to continue or write new directory location, As an example: `types` folder in root directory.

2. Select export type.
```cmd
Please select export type:
1. classic
2. json_serializable
3. freezed
Write [1-3] or [classic, json_serializable, freezed]:
```
You can enter export type id or name.

> The classic type does not require to **dart run json_convert build** but it does for **freezed** and **json_serializable**!

3. Complete selected type methods checkmarks:
   `some questions for adding methods`

4. Choose export directory:
   Default export directory is `lib/models`.
```cmd
Export location inside lib folder: `models`
Do you want to change it?
[Press Enter / Write new location]:
```
You can press Enter to continue or write new directory location, As an example: `entities` folder inside `lib` directory.

> Do not include the ~~`lib`~~ at the beginning of the address!