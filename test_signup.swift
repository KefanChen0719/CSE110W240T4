// BDD Test Sign up

func test_signup()) {
  // test invalid user name
  let username = "test_user"
  let password = "test_pw"
  let originalSize = messageDatabase.size
  userDatabase.save(username, password)

  // The size of the database should not increase
  XCTAssertEqual(messageDatabase.size, originalSize)

  // The size should increase by 1 if use a valid username
  let username = "test_user@ucsd.edu"
  userDatabase.save(username, password)
  XCTAssertEqual(messageDatabase.size, originalSize + 1)

  // username should be the same as "username"
  let storedData = userDatabase.get(userDatabase.size-1).value["username"]
  XCTAssertEqual(storedData, username)

  // The app should now bring me to [mygroup] view
  XCTAssertTrue(self.window.rootViewController is myGroupsViewController)
}