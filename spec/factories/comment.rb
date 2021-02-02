FactoryBot.define do
    factory :comment do
      association :post
   
      comment { 'fsdfdsfsdfsdfsdfsdf' }

      author_id { 1 }

      trait(:with_too_long_text) do 
        comment { FFaker::String.random(length: 201) }
      end
    end
  end