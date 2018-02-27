
require "../src/my_git"

require "da_spec"

extend DA_SPEC

describe "My_Git::Files.load_changes" do
  it "works" do
    My_Git::Files.load_changes
    assert true == true
  end # === it "works"
end # === desc "My_Git::Files.load_changes"

describe "My_Git::Files.changed?" do
  it "returns a Boolean" do
    actual = My_Git::Files.changed?(".gitignore", Time.now.epoch)
    assert actual == true
  end # === it "returns a Boolean"

  it "returns false if file has not been changed" do
    actual = My_Git::Files.changed?(".gitignore", File.stat(".gitignore").mtime.epoch)
    assert actual == false
  end # === it "returns false if file has not been changed"
end # === desc "My_Git::Files.changed?"

describe "My_Git::Files.update_log" do
  it "works" do
    My_Git::Files.update_log
    assert My_Git::Files.changed_files.empty? == true
  end # === it "works"
end # === desc "My_Git::Files.update_log"
