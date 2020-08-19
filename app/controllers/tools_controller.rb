class ToolsController < ApplicationController
  def index
    @tools = Tool.all.order('created_at DESC')
  end

  def create
    json_tool_spec = GithubAPI.new
                       .get_file_content(tool_name: tool_params["name"], language: tool_params["language"])

    tool = Tool.new(tool_params.merge!({ json_spec: json_tool_spec }))
    tool.save!

    LokaliseAPI.new
      .create_translation_keys(
        translations: create_translation(tool_name: tool_params["name"], json_tool_spec: json_tool_spec),
        language: tool_params["language"])

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Tool was successfully created.' }
      format.json { render :show, status: :created, location: tool }
    end
  end

  def new
    @tool = Tool.new
  end

  def show
    @tool = Tool.find(params[:id])
  end

  private

  def create_translation(tool_name:, json_tool_spec:)
    translations = {}
    translations["#{tool_name}_language"] = json_tool_spec["language"]
    translations["#{tool_name}_result_resultRanges_#{tool_name.downcase}_title"] = json_tool_spec.dig("result", "resultRanges", tool_name.downcase, "title")
    translations["#{tool_name}_result_resultRanges_#{tool_name.downcase}_activityLevel"] = json_tool_spec.dig("result", "resultRanges", tool_name.downcase, "activityLevel")

    translations
  end

  def tool_params
    params.require(:tool).permit(:name, :language)
  end
end
