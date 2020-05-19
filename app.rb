require './lib/listing.rb'
require 'sinatra/flash'
require 'sinatra/base'
require './database_connection_setup'
require './lib/user'

class MakersBnB < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    @listings = Listing.all
    @user = User.find(id: session[:user_id])
    erb :index
  end

  get '/listings/new' do
    erb :'listings/new'
  end

  get '/listings/:id/show' do
    p params
    #@listing = Listing.find(id: params[:id])
    erb (:'listings/show') # I know this works now 
  end

  post '/listings' do
    Listing.create(name: params[:name], description: params[:description], price: params[:price])
    flash[:notice] = "Your listing has been added"
    redirect '/'
  end

  get '/signup' do
    flash[:notice] = "this username/email already exists"
    erb(:signup)
  end

  post '/register' do
    begin
      user = User.create(email: params[:email], username: params[:username], password: params[:password])
    rescue PG::UniqueViolation
      redirect '/signup'
    end
    session[:user_id] = user.id
    redirect '/'
  end

  run! if app_file == $0
end
