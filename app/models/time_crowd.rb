class TimeCrowd
  attr_accessor :client, :access_token

  def initialize
    self.client = OAuth2::Client.new(
      ENV['TIMECROWD_CLIENT_ID'],
      ENV['TIMECROWD_SECRET_KEY'],
      site: 'https://timecrowd.net',
      ssl: { verify: false }
    )
    self.access_token = OAuth2::AccessToken.new(
      client,
      self.get 'token',
      refresh_token: self.get 'refresh_token',
      expires_at: self.get 'expires_at'
    )
  end

  def teams(state = nil)
    access_token.get("/api/v1/teams?state=#{state}").parsed
  end

  def team(id)
    access_token.get("/api/v1/teams/#{id}").parsed
  end

  def team_tasks(team_id, state = nil)
    access_token.get("/api/v1/teams/#{team_id}/tasks?state=#{state}").parsed
  end

  def update_team_task(team_id, id, body)
    access_token.put("/api/v1/teams/#{team_id}/tasks/#{id}", body: body).parsed
  end

  def user_info
    access_token.get("/api/v1/user/info.json").parsed
  end

  def time_entries page = nil
    url = '/api/v1/time_entries'
    url += "?page=#{page}" unless page.nil?
    puts url
    access_token.get(url).parsed
  end

  def create_time_entry(task)
    access_token.post(
      "/api/v1/time_entries",
      body: {task: task}
    ).parsed
  end

  def self.get key
    File.open("tmp/timecrowd_#{key}.txt", 'r').read
  end

  def self.set key, val
    File.open("tmp/timecrowd_#{key}.txt", 'w') { |file| file.write(val) }
  end
end

