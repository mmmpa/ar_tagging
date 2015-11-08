FactoryGirl.define do
  factory :tagged do
    trait :valid do
      name { "tagged #{SecureRandom.hex(4)}" }
    end
  end
end
