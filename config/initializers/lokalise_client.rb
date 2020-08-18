require 'ruby-lokalise-api'

class LokaliseClient
  def self.instance
    @instance ||= Lokalise.client Rails.application.credentials.dig(:lokalise, :api_key)
  end
end
