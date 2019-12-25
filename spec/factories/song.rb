FactoryBot.define do
  factory :song do
    sequence(:name) { |n| "title#{n}" }
    sequence(:description) { |n| "description#{n}" }

    trait :no_name do
      name {}
    end

    trait :no_description do
      description {}
    end

    trait :no_image do
      image {}
    end

    trait :no_lylics_url do
      lylics_url {}
    end

    trait :no_track_url do
      track_url {}
    end

    trait :no_artist_url do
      artist_url {}
    end

    trait :too_long_description do
      description {Faker::Lorem.characters(number: 301)}
    end
  end
end
