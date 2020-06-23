require 'sinatra'
require 'sinatra/json'
require 'bundler'
require 'pry'
require 'data_mapper'

Bundler.require
require 'review'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!

get '/' do
	"Hello World"
end

get '/reviews' do
	content_type :json
	reviews = Review.all
	reviews.to_json
end

get '/reviews/:id' do
	content_type :json
	review = Review.get params[:id]
	review.to_json
end

post '/reviews' do
	review = Review.create(name: params[:review][:name], text: params[:review][:text])
	if review.save
		status 201
	else
		status 500
		json  review.errors.full_messages
	end
end

put '/reviews/:id' do
	review = Review.get params[:id]
	if review.update params[:review]
		status 200
		json "Review was updated"
	else
		status 500
		json review.errors.full_messages
	end
end

delete '/reviews/:id' do
	content_type :json
	review = Review.get params[:id]
	if review.destroy
		status 200
		json "Review was removed."
	else
		status 500
		json "There was a problem in deleting the review."
	end
end
