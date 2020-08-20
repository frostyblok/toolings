FactoryBot.define do
  factory :tool do
    name { "BMI" }
    language { "en" }
    json_spec { { test: "yes", should_pass: "yes"} }
  end
end
