require 'base64'
require 'json'

class GithubAPI
  attr_reader :client, :repo

  def initialize
    @client = OctokitClient.instance
    @repo = ENV['REPO_NAME']
  end

  def get_file_content(tool_name:, language:)
    file_path = get_translation_file(tool_name: tool_name, language: language)

    json_content(file_path: file_path)
  end

  def create_pull_request(tool_name:, language:, content:)
    sha = Rails.application.credentials.dig(:github, :master_sha)
    branch_name = "update_#{tool_name}_to_#{language}"

    # Create a new branch
    client.create_ref(repo, "refs/heads/#{branch_name}", sha)

    # Create content by adding and committing changes
    client.create_contents(
      repo,
      "lib/assets/#{tool_name}.#{language}.json",
      "Update #{language} translation for #{tool_name}",
      content,
      branch: branch_name
    )

    client.create_pull_request(repo, 'master', branch_name, "Update #{language} translation for #{tool_name}")
  end

  private

  def json_content(file_path:)
    encoded_content = client.contents(repo, path: file_path).content

    decoded_content = Base64.decode64(encoded_content)
    JSON.parse(decoded_content)
  end

  def get_translation_file(tool_name:, language:)
    Dir.glob("lib/assets/#{tool_name}.#{language}*.json")[0]
  end
end
