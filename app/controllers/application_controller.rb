# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :initialize_session
  before_action :get_session_id

  private

  def initialize_session
    session[:started_at] ||= Time.current.to_i
  end

  def get_session_id
    @session_id = session.id.to_s
  end
end
