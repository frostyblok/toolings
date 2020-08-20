class LokaliseApisController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_lokalise_webhook_token?

  def webhook
    @all_keys ||= LokaliseAPI.new.get_keys
    @all_translations ||= LokaliseAPI.new.get_translations

    mapped_key_id_and_key_name = @all_keys.collection.map do |key|
      [key.key_name["web"], key.key_id]
    end.to_h

    mapped_key_id_and_translation = @all_translations.collection.map do |translation|
      [translation.translation, translation.key_id]
    end.to_h

    @translations_with_key_names_and_key_id = mapped_key_id_and_key_name.merge(mapped_key_id_and_translation)

    replace_json_with_updated_translations

    GithubAPI.new.create_pull_request(
      tool_name: tool_name,
      language: replace_json_with_updated_translations["language"]&.downcase,
      content: JSON.pretty_generate(replace_json_with_updated_translations)
    )
  end

  private

  def updated_translations
    @translations_with_key_names_and_key_id.transform_keys.map { |key| key }.each_slice(2).to_h
  end

  def tool_name
    updated_translations.keys.first.partition('_').first
  end

  def master_json_spec
    @master_json_spec ||= GithubAPI.new.get_file_content(tool_name: tool_name, language: '')
  end

  def replace_json_with_updated_translations
    master_json_spec["language"] = updated_translations["#{tool_name}_language"]
    master_json_spec["result"]["resultRanges"][tool_name.downcase]["title"] = updated_translations["#{tool_name}_result_resultRanges_#{tool_name.downcase}_title"]
    master_json_spec["result"]["resultRanges"][tool_name.downcase]["activityLevel"] = updated_translations["#{tool_name}_result_resultRanges_#{tool_name.downcase}_activityLevel"]

    master_json_spec
  end

  def valid_lokalise_webhook_token?
    params["event"] == Rails.application.credentials.dig(:lokalise, :update_translation_event)
  end
end
