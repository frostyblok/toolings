class OctokitClient
  def self.instance
    @instance ||= Octokit::Client.new(access_token: Rails.application.credentials.dig(:github, :access_token))
  end
end
