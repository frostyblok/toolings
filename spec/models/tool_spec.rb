require 'rails_helper'

RSpec.describe Tool, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:language) }
  it { should validate_presence_of(:json_spec) }
end
