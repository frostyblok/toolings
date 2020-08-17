class Tool < ApplicationRecord
  validates :name, :language, :json_spec, presence: true
end
