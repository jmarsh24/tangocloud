require "test_helper"

class PlaybackQueueTest < ActiveSupport::TestCase
  def setup
    @user = users(:tester)
    @recordings = [recordings(:la_cumparsita), recordings(:el_choclo)]
    @playback_queue = PlaybackQueue.create!(user: @user)
  end

  test "should be valid with a user" do
    assert @playback_queue.valid?
  end

  test "should require a user" do
    playback_queue = PlaybackQueue.new
    assert_not playback_queue.valid?
    assert_includes playback_queue.errors[:user], "can't be blank"
  end

  test "should load recordings and set current_item" do
    @playback_queue.load_recordings(@recordings)
    assert_equal @recordings.first, @playback_queue.current_item.item
    assert @user.playback_session.playing?
    assert_equal @recordings.size, @playback_queue.queue_items.count
  end

  test "should rotate recordings to start with specified recording" do
    start_with = recordings(:el_choclo)
    @playback_queue.load_recordings(@recordings, start_with: start_with)
    assert_equal start_with, @playback_queue.current_item.item
  end

  test "should play a specific recording" do
    recording = recordings(:la_cumparsita)
    @playback_queue.play_recording(recording)
    assert_equal recording, @playback_queue.current_item.item
    assert @user.playback_session.playing?
  end

  test "should move to next item in the queue" do
    @playback_queue.load_recordings(@recordings)
    current_item = @playback_queue.current_item
    @playback_queue.next_item
    assert_not_equal current_item, @playback_queue.current_item
  end

  test "should move to previous item in the queue" do
    @playback_queue.load_recordings(@recordings)
    current_item = @playback_queue.current_item
    @playback_queue.previous_item
    assert_not_equal current_item, @playback_queue.current_item
  end

  test "should add a recording to the queue" do
    new_recording = recordings(:el_choclo)
    @playback_queue.add_recording(new_recording)
    assert_includes @playback_queue.recordings, new_recording
  end

  test "should select a recording and play it" do
    @playback_queue.load_recordings(@recordings)
    recording = @recordings.last
    @playback_queue.select_recording(recording)
    assert_equal recording, @playback_queue.current_item.item
    assert @user.playback_session.playing?
  end

  test "should remove a recording from the queue" do
    @playback_queue.load_recordings(@recordings)
    recording_to_remove = @recordings.first

    if @playback_queue.current_item.item == recording_to_remove
      @playback_queue.remove_recording(recording_to_remove)
      assert_not_equal recording_to_remove, @playback_queue.current_item&.item
    else
      @playback_queue.remove_recording(recording_to_remove)
    end

    assert_not_includes @playback_queue.recordings, recording_to_remove
  end

  test "should ensure default items when queue is empty" do
    @playback_queue.ensure_default_items
    assert_not @playback_queue.queue_items.empty?
  end
end
