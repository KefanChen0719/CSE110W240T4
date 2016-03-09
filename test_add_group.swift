// BDD Test add group

func test_add_group() {
  // add a group
  let group = self.groups[0]
  let originalSize = myGroup.size
  didTapButton(curr_group)

  // The size of the database should have increased by one
  XCTAssertEqual(myGroup.size, originalSize + 1)

  // the uid saved in the database should be the same
  let uid = myGroup.get(myGroup.size - 1).value["uid"]
  XCTAssertEqual(uid, group.value["uid"]
}