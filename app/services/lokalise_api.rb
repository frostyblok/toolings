class LokaliseAPI
  attr_reader :client

  def initialize
    @client = LokaliseClient.instance
  end

  def create_translation_keys(translations:, language:)
    keys = translations.map do |translation_key, translation_value|
      {
        key_name: {
          ios: translation_key,
          android: translation_key,
          web: translation_key,
          other: translation_key,
        },
        platforms: %w(web ios android other),
        translations: [({ language_iso: language, translation: translation_value })]
      }
    end

    client.create_keys(Rails.application.credentials.dig(:lokalise, :project_id), keys)
  end

  def get_translations
    client.translations(Rails.application.credentials.dig(:lokalise, :project_id))
  end

  def get_keys
    client.keys(Rails.application.credentials.dig(:lokalise, :project_id))
  end
end
