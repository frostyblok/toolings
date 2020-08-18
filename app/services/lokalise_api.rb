class LokaliseAPI
  attr_reader :client, :translations, :language

  def initialize(translations:, language:)
    @client = LokaliseClient.instance
    @translations = translations
    @language = language
  end

  def create_translation_keys
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
end
