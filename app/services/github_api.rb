require 'base64'
require 'json'

class GithubAPI
  attr_reader :client, :tool_name, :language

  def initialize(tool_name:, language:)
    @client = OctokitClient.instance
    @tool_name = tool_name
    @language = language
  end

  def get_file_content
    repo = ENV['REPO_NAME']
    file_path = Dir.glob("lib/assets/#{tool_name}.#{language}*.json")[0]

    encoded_content = client.contents(repo, path: file_path).content

    decoded_content = Base64.decode64(encoded_content)
    JSON.parse(decoded_content)
  end
end
