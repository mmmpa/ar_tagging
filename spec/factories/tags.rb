FactoryGirl.define do
  factory :tag do
    trait :valid do
      name { "tag #{SecureRandom.hex(4)}" }
    end
  end
end
