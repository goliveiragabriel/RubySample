class AuthorizedController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  check_authorization
  load_and_authorize_resource
end