## Welcome to Plock!
Plock! is newest and greatest bookmark-saving application! Simply follow these steps to gain access to the best of Plock!

## Saving Bookmarks
Bookmarks shoud be saved at "/my_bookmarks"

  Plock! will save any link that you wish to save! The link must be a valid URL, and you must create a name for that link and give it a description.

    * Put your username(Slack account name) and password into the form that you are greeted with.
      * the body of your request must have your username and password.
      * Error 400-the username and password that you entered were not found! Please try again!

    * Give your bookmark a name, description, and URL.
      * Error 422-you did not enter a valid url! Try again with one that starts with "http" or "https"
      * The body of your request must have your name(of bookmark), bookmark_url, and bookmark_description.

    * Hit that submit button!
      * ValidationError-you did not enter all the required data. Please fill out the form completely.

    * You're done! You can see your bookmark if you refresh.

## Making a Recommendation
Recommendations should be made to "/recommendations"

  Next to any bookmark that you have created you can click on a recommendation button! Recommendations will post to Slack and will alert the sender and the reciever that a recommendation has been made!

  * Put your username(Slack account name) and password into the form that you are greeted with.
    * the body of your request must have your username and password.
    * Error 400-the username and password that you entered were not found! Please try again!

  * Enter the Slack username of the person that you want to recieve the recommendation.
    * you should also enter this into the body of the request.

  * Click that submit button!
    * ValidationError-you did not enter all the required data. Please fill out the form completely.

  * Done! Your recommendation should have posted to Slack.

  Made by Alyssa Pratt and Jorge ['Vega'] Ramirez
