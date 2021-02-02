# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/favicon.png')) }

    trait(:with_invalid_avatar) do
      avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.txt')) }
    end

    trait(:with_invalid_short_password) do
      password { '12' }
      password_confirmation { '12' }
    end

    trait(:with_password_confirmation_dismath) do
      password_confirmation { 'dfsdfsdfsdf' }
    end

    trait(:with_not_an_email) do
      email { 'dfsdfsdf' }
    end
  end
end
