[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Layout Customization

### Overview

You can customize the position and layout of message components by overriding the XML layout files in your application. Each message container has its own layout file that can be customized.

### Layout Files

The SDK provides three main layout files for message containers:

- **`aa_view_other_message.xml`**: Layout for messages from other participants (LEFT container type)
- **`aa_view_my_message.xml`**: Layout for messages from current user (RIGHT container type)
- **`aa_view_admin_message.xml`**: Layout for admin/system messages (PLAIN container type)

### How to Override Layouts

**Step 1: Create Layout Files in Your App**

Create layout files with **exactly the same name** in your app's `res/layout/` directory:

```
your-app/
├── src/main/res/layout/
│   ├── aa_view_other_message.xml
│   ├── aa_view_my_message.xml
│   └── aa_view_admin_message.xml
```

**Step 2: Customize Layout Structure**

You can modify the position, size, and arrangement of views in these layouts:

### Important Requirements

#### 1. Keep Required View IDs

All views must maintain their original IDs for SDK functionality:

- `ivProfile`: Profile image view
- `tvNickname`: Nickname text view
- `tvSentAt`: Sent time text view
- `contentPanel`: Content container
- `statusContainer`: Status container (MyMessage only)
- `statusView`: Status view (MyMessage only)
- `messageTemplateView`: Message template view (OtherMessage only)
- `suggestedRepliesViewStub`: Suggested replies view stub (OtherMessage only)

#### 2. Don't Remove Views

**Never remove views from the layout XML**. If you want to hide a view, use the Container class methods to control visibility:

```kotlin
class CustomOtherMessageContainer(context: Context) : OtherMessageContainer(context) {

    override fun drawProfile(profileView: ImageView, channel: GroupChannel, message: BaseMessage, messageUIParams: MessageUIParams) {
        // Hide profile image
        profileView.visibility = View.GONE
    }

    override fun drawNickname(textView: TextView, message: BaseMessage, messageUIParams: MessageUIParams) {
        // Hide nickname
        textView.visibility = View.GONE
    }

    override fun drawSentAt(textView: TextView, message: BaseMessage, messageUIParams: MessageUIParams) {
        // Hide sent time
        textView.visibility = View.GONE
    }
}
```
