module TurboHelper
  def wait_for_turbo(timeout = 2)
    if has_css?(".turbo-progress-bar", visible: true, wait: 0.25.seconds)
      has_no_css?(".turbo-progress-bar", wait: timeout)
    end
  end

  def wait_for_turbo_stream_connected(streamable: nil)
    if streamable
      signed_stream_name = Turbo::StreamsChannel.signed_stream_name(streamable)
      assert_selector("turbo-cable-stream-source[connected][channel=\"Turbo::StreamsChannel\"][signed-stream-name=\"#{signed_stream_name}\"]", visible: :all)
    else
      assert_selector("turbo-cable-stream-source[connected][channel=\"Turbo::StreamsChannel\"]", visible: :all)
    end
  end
end
