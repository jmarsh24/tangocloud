module TandasHelper
  def formatted_tanda_duration(tanda)
    total_seconds = tanda.duration
    minutes, seconds = total_seconds.divmod(60)
    "#{minutes} min #{seconds} sec"
  end
end
