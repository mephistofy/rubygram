FactoryBot.define do
    factory :comment do
      association :post
   
      comment { 'fsdfdsfsdfsdfsdfsdf' }

      author_id { 1 }

      trait(:with_too_long_text) do 
        comment { Faker::String.random(length: 201) }
      end
    end
  end