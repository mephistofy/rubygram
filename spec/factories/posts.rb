FactoryBot.define do
  factory :post do
    association :user
 
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.jpg')) }
  
    trait(:with_invalid_image) do 
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.txt')) }
    end

    trait(:with_default_image) do
      image { }
    end
  end
end