FactoryBot.define do
  factory :tool do
    name { "MyString" }
    language { "MyString" }
    json_spec { { test: "yes", should_pass: "yes"} }
  end
end
