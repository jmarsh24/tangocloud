require "test_helper"

class PlaybackSessionTest < ActiveSupport::TestCase
  def setup
    @user = users(:tester)
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

  test "should reset position to 0 when starting a new recording" do
    @playback_session.position = 100
    @playback_session.play(reset_position: true)
    assert @playback_session.playing
    assert_equal 0, @playback_session.position
  end

  test "should not reset position when playing without reset" do
    @playback_session.position = 100
    @playback_session.play
    assert @playback_session.playing
    assert_equal 100, @playback_session.position
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

# == Schema Information
#
# Table name: playback_sessions
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  playing    :boolean          default(FALSE), not null
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
