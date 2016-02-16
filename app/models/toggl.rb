class Toggl
  def initialize
    token = ENV['TOGGL_TOKEN']
    @toggl    = TogglV8::API.new(token)
    @user         = @toggl.me(all=true)
    @workspaces   = @toggl.my_workspaces(@user) # 通常は1つ？
    @workspace_id = @workspaces.first['id']
  end

  def workspaces
    @workspaces
  end

  def working
    @toggl.get_current_time_entry
  end

  def time_entries
    @toggl.get_time_entries
  end

  def last
    time_entries.last
  end

  def start
    return if working # 既に動いていたら実行しない 
    @toggl.start_time_entry({
      'description' => last['description'],
      'wid' => @workspace_id,
      'start' => Time.now,
      'created_with' => "http://245cloud.com"
    })
  end

  def stop
    @toggl.stop_time_entry(working['id'])
  end
end

