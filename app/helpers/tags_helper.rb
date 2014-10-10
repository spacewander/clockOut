module TagsHelper

  # convert into chinese date format
  # Params:
  # +date+:: +Date+ Object
  def chinese_date_format(date)
    return if date.nil?
    year = date.year
    month = date.mon
    day = date.mday

    "#{year}年#{month}月#{day}日"
  end

  # generate a bootstrap progress-bar with percents and custom options
  # Params:
  # +percents+:: +Fixnum+ between 0 to 1.00
  # +options+::
  # alternative: ['success', 'danger', 'warning', 'info']
  def progress_bar(percents, options)
    percents *= 100

    case options[:alternative]
      when 'success'
      alternative = 'progress-bar-success'
      when 'danger'
      alternative = 'progress-bar-danger'
      when 'warning'
      alternative = 'progress-bar-warning'
      when 'info'
      alternative = 'progress-bar-info'
      else
      alternative = ''
    end

    raw "<div class='progress'>
    <div class='progress-bar #{alternative}' role='progressbar'
      aria-valuenow='#{percents}' aria-valuemin='0' aria-valuemax='100'
      style='width: #{percents}%'>
      <span class='sr-only'>#{percents}%</span>
    </div>
  </div>"
  end

end
