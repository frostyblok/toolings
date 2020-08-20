require 'rails_helper'

RSpec.describe 'GithubApi', type: :request do
  subject(:call) { post '/github/webhook', params: params, as: :son, headers: headers }

  let!(:tool) { create(:tool) }
  let(:params) { { "github" => 'random github params' } }
  let!(:json_spec) { { "test" => "yes", "should_not_pass" => "no"} }
  let(:headers) do
    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('my', 'cred')
    }
  end

  before do
    allow_any_instance_of(GithubAPI).to receive(:parse_params).with(params_payload: params["payload"]) {
      {
        "pull_request" => {
          "title" => "Updated it translation for BMI"
        }
      }
    }
    allow(OctokitClient).to receive(:instance)
    allow_any_instance_of(GithubAPI).to receive(:get_file_content) { json_spec }
  end

  it 'returns a successful response' do
    call
    expect(Tool.last.json_spec).to eq(json_spec)
  end
end
