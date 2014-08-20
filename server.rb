require 'sinatra'
require 'csv'
require 'pry'

#################
#Read movie information from CSV file to array of hashes
################

def get_movie_info(filename)
  movies = {}

  CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
    movies[row[:id].to_i] = {title: row[:title], year: row[:year], synopsis: row[:synopsis], rating: row[:rating], genre: row[:genre], studio: row[:studio]}
  end
  movies
end

# {3 => {
#  :title=>"The Royal Tenenbaums",
#  :year=>2002,
#  :synopsis=>"",
#  :rating=>80,
#  :genre=>"Comedy",
#  :studio=>"Buena Vista Distribution Compa"}
# }

def get_movie_list(filename)
  movie_list = []

  CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
    movie_list << row.to_hash
  end

  movie_list
end

def symbol_sort(filename, symbol)
  array_of_hashes = get_movie_list('movies.csv')
  sorted_hash = array_of_hashes.sort_by{|hash| hash[symbol]}
end


####################
#Home page display
####################

get '/' do
  erb :index
end

##################
#Complete movie list display
##################

get '/movies' do
  @movies_byname = symbol_sort('movies.csv', :title)
  erb :movie_list
end

##################
#Complete individual movie page display
##################

get'/movies/:idno' do
  @movie_info = get_movie_info('movies.csv')
  @each_movie = @movie_info[params[:idno].to_i]
  erb :movie_view
end

get '/results' do
  params
  @movies_byname = symbol_sort('movies.csv', :title)
  erb :results_view
end



