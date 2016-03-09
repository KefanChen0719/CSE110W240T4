// BDD Test Chat

func test_chat() {
  // Given: I type in any words and click submit button
  let originalSize = messageDatabase.size  // current database size
  let sender = "test_user"  // sender's id
  let text = "Hello World"  // text to send
  let date = NSDate()  // initialize a NSDate object

  // simulate pressing button
  didPressSendButton(sendButton, text, sender, date)  

  // The size of the database should have increased by one.
  XCTAssertEqual(messageDatabase.size, originalSize + 1)

  // The message saved to and loaded from the database should be the same.
  XCTAssertEqual(messageDatabase.get(messageDatabase.size-1).value["text"], text);

  // The last message in the view should be same as text
  let messegsList = messageViewController.messages
  XCTAssertEqual(messagesList[messsages.size], text);
}