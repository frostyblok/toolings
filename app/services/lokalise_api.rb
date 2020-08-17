class LokaliseAPI
  attr_reader :name, :translation, :client

  def initialize(translations:, name:)
    @client = LokaliseClient.instance
    @translations = translations
    @name = name.downcase
  end

  def create_translation_keys
    params = {
      key_name: {
        ios: "#{name}_ios",
        android: "#{name}_android",
        web: "#{name}_web",
        other: "#{name}_other"
      },
      platforms: %w(ios android web other),
      translations: [translations]
    }
    client.create_keys(Rails.application.credentials.dig(:lokalise, :api_key), params)
  end
end
