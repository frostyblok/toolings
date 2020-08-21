class GithubApiController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_github_webhook_token?

  TOOL_NAME_POSITION = 4
  LANGUAGE_POSITION = 1

  def webhook
    @payload_params_hash = GithubAPI.new.parse_params(params_payload: params["payload"])

    params_hash_title = @payload_params_hash["pull_request"]["title"]
    params_title_array = params_hash_title.scan(/\w+/)

    tool_name = params_title_array[TOOL_NAME_POSITION]
    language = params_title_array[LANGUAGE_POSITION]


    json_spec = GithubAPI.new.get_file_content(tool_name: tool_name, language: language)

    tool = Tool.find_by(name: tool_name)
    tool.update( json_spec: json_spec ) if tool
  end

  def create_webhook
    GithubAPI.new.create_webhook
  end

  private

  def valid_github_webhook_token?
    return true if ENV["RAILS_ENV"] == 'test'

    request.headers["X-GitHub-Event"] == ENV["GITHUB_WEBHOOK_EVENT"] &&
      @payload_params_hash["action"] == ENV["GITHUB_WEBHOOK_ACTION"] &&
        @payload_params_hash["pull_request"]["merged"]
  end
end
