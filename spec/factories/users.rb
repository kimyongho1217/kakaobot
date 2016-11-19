FactoryGirl.define do
  factory :user do |f|
    f.email "test@email.com"
    f.password "password"
    f.password_confirmation "password"
    f.confirmed_at Time.now
  end

  factory :dup_user, class: User do |f|
    f.email "test@email.com"
    f.password "password"
    f.password_confirmation "password"
    f.confirmed_at Time.now
  end

  factory :another_user, class: User do |f|
    f.email "test1@email.com"
    f.password "password"
    f.password_confirmation "password"
    f.confirmed_at Time.now
  end

  factory :user_without_confirm, class: User do |f|
    f.email "test2@email.com"
    f.password "password"
    f.password_confirmation "password"
  end
end
