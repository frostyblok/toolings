require 'rails_helper'

RSpec.describe ToolsController, type: :controller do
  let(:tool_name) { 'SPA' }
  let(:tool_language) { 'it' }
  let(:json_spec) { { "test" => "yes", "should_pass" => "yes"} }

  context "#create" do
    before do
      allow_any_instance_of(GithubAPI).to receive(:get_file_content) {json_spec}
      allow_any_instance_of(LokaliseAPI).to receive(:create_translation_keys)

      get :create, params: { name: tool_name, language: tool_language }
    end

    it "should create a tool" do
      expect(Tool.last.name).to eq(tool_name)
      expect(Tool.last.language).to eq(tool_language)
      expect(Tool.last.json_spec).to eq(json_spec)
    end

    context 'raises a validation error when an attribute is missing' do
      let(:tool_name) { '' }

      it 'return validation error' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end
end
