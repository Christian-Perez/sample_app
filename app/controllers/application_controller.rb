class ApplicationController < ActionController::Base
  def hello
    render html: "it's working!"
  end
end
