# MemeMe
MemeMe app final version

MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also stores and persists sent memes which users can browse in a table or a grid.
The app has three pages of content:      
  
● **Meme Editor View**: Enables a user to add text to an image and share it.  
● **Sent Memes View**: Enables a user to browse sent memes in a table or a grid.  
● **Meme Detail View**: Displays an image of a sent meme  

####User flow  
When the user first launches the app the **Sent Memes View** appears. It is the root view of the navigation stack. When the user taps the + button in the top right corner the app pushes the **Meme Editor View** on top of the **Sent Memes View**.
In the **Meme Editor View**, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.
After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed and persisted.
When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme. After an option is chosen, the Activity View is dismissed and the **Sent Memes View** appears. The **Sent Memes View** also appears upon pressing the “Cancel” button.
Selecting a meme from the table or collection presents the **Meme Detail View**. Clicking on the  back arrow of the **Meme Detail View** presents the previous **Sent Memes View**, either the table or collection.  

