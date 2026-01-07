[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## How to Customize the Message Bubble Max Width

On Android, the resource values defined in the dimens.xml file are used to set the maximum width of a Bubble.
In the application, you can easily change the value by overriding the corresponding key.

- Create a **`dimens.xml`** file (skip if it already exists)
- Create an element with the key **`aa_message_max_width`** and enter the desired value

**dimens.xml**
```xml
<dimen name="aa_message_max_width">300dp</dimen>
```
