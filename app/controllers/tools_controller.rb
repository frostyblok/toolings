class ToolsController < ApplicationController
  def create
    json_tool_spec = GithubAPI.new(
      tool_name: tool_params["name"], language: tool_params["language"]
    ).get_file_content

    tool = Tool.new(tool_params.merge!({json_spec: json_tool_spec }))
    tool.save!

    LokaliseAPI
      .new(
        translations: create_translation(
                        tool_name: tool.name, json_tool_spec: json_tool_spec
                      ), name: tool_params["name"]
      ).create_translation_keys

  rescue ActiveRecord::RecordInvalid => e
    render json: e.message
  end

  private

  def create_translation(tool_name:, json_tool_spec:)
    translations = {}
    translations["#{tool_name}_language"] = json_tool_spec["language"]
    translations["#{tool_name}_result_resultRanges_#{tool_name.downcase}_title"] = json_tool_spec.dig("result", "resultRanges", "#{tool_name.downcase}", "title")
    translations["#{tool_name}_result_resultRanges_#{tool_name.downcase}_activityLevel"] = json_tool_spec.dig("result", "resultRanges", "#{tool_name.downcase}", "activityLevel")
  end

  def tool_params
    params.permit(:name, :language)
  end
end
