class UserSerializer < ApplicationSerializer
  attributes  :id,
              :email,
              :api_token
end
