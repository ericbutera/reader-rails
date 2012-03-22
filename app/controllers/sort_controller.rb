class SortController < ApplicationController 
  before_filter :authenticate

  def set
    session[:sort] = params[:sort].to_i
  end

end
