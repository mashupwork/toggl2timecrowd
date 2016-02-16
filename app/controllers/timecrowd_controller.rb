class TimecrowdController < ApplicationController
  def index
  end

  def login
    auth_hash = request.env['omniauth.auth']
    %w(expires_at refresh_token token).each do |key|
      val = auth_hash.credentials.send(key)
      TimeCrowd.set(key, val)
    end
    redirect_to '/?timecrowd=1', notice: 'Signed in successfully'
  end
end

