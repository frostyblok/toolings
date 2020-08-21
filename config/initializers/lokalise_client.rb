require 'ruby-lokalise-api'

class LokaliseClient
  def self.instance
    @instance ||= Lokalise.client ENV["LOKALISE_API_KEY"]
  end
end
