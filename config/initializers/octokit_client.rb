class OctokitClient
  def self.instance
    @instance ||= Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])
  end
end
