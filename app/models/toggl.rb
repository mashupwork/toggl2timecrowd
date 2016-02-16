class Toggl
  def initialize
    token = ENV['TOGGL_TOKEN']
    @toggl    = TogglV8::API.new(token)
    @user         = @toggl.me(all=true)
    @workspaces   = @toggl.my_workspaces(@user) # 通常は1つ？
    @workspace_id = @workspaces.first['id']
  end

  def time_entries
    @toggl.get_time_entries
  end
end

