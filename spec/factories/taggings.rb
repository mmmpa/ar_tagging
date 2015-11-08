FactoryGirl.define do
  factory :tagging do
    trait :valid do
      tagged { create(:tagged, :valid) }
      tag { create(:tag, :valid) }
    end
  end
end
