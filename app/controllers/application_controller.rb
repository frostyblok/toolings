class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :error_handler
  rescue_from ActiveRecord::RecordNotFound, with: :error_handler
  rescue_from Lokalise::Error::BadRequest, with: :error_handler

  private

  def error_handler(error)
    render json: error.message
  end
end
