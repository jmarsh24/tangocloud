require "test_helper"

class PlaybackSessionTest < ActiveSupport::TestCase
  def setup
    @user = users(:tester)
    @queue_item = queue_items(:tester_la_cumparsita)
    @playback_session = PlaybackSession.new(user: @user)
  end

  test "should be valid with a user" do
    assert @playback_session.valid?
  end

  test "should require a user" do
    @playback_session.user = nil
    assert_not @playback_session.valid?
    assert_includes @playback_session.errors[:user], "can't be blank"
  end

  test "should be able to play" do
    @playback_session.play
    assert @playback_session.playing
  end

  test "should be able to pause" do
    @playback_session.play
    @playback_session.pause
    assert_not @playback_session.playing
  end

  test "should be able to seek to a specific position" do
    new_position = 120
    @playback_session.seek(new_position)
    assert_equal new_position, @playback_session.position
  end
end
