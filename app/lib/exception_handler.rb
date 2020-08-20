module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # custom handler
    rescue_from ActiveRecord::RecordInvalid, with: :error_handler
    rescue_from ActiveRecord::RecordNotFound, with: :error_handler
    rescue_from Lokalise::Error::BadRequest, with: :error_handler
    rescue_from Octokit::InvalidRepository, with: :error_handler
    rescue_from Octokit::UnprocessableEntity, with: :error_handler
    rescue_from Octokit::MissingContentType, with: :error_handler
    rescue_from Octokit::Conflict, with: :error_handler
    rescue_from Octokit::NotFound, with: :error_handler
  end

  private

  def error_handler(error)
    render json: error.message
  end
end
