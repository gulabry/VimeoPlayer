# VimeoPlayer

### Architecture:

- I am using a basic MVC style along with certain manager classes to handle loading of assets and model data.

### Improvements:

- Adding a AVPlayerQueue to hold all the currently loading AVPlayerAssets so any loading of videos could be resumed where they stopped downloading.

- Passing the current playing time into the popup video player so the Video can continue from where it was on the home page.

- Adding an Interactive Transition to dismiss the Video player after is animates into full screen mode.

- Adding KVO on the AVPlayers in the PageViewController that holds all the Videos such that it would remember all the status' of the player state: play/pause/mute.

- I would build a custom VimeoAPI parser instead of using a Cocoapod, I realized it was not as straight forward of a streaming API as I initially thought.

