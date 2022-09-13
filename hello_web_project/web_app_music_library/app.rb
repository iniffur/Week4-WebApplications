# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'
require 'json'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  post '/albums' do
    album = Album.new 
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo = AlbumRepository.new
    repo.create(album)
  end

  # get '/albums/:id' do
  #   album_id = params[:id]
  #   repo = AlbumRepository.new
  #   album = repo.find(album_id)
  #   hash = {
  #     :title => album.title, 
  #     :release_year => album.release_year,
  #     :artist_id => album.artist_id,
  #     :id => album.id
  #   }
  #   return JSON.generate(hash)
  # end

  # get '/artists' do
  #   repo = ArtistRepository.new
  #   artists = repo.all
  #   artists.map {|artist| artist.name}.join(', ')
  # end

  post '/artists' do
    artist = Artist.new
    artist.id = params[:id]
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo = ArtistRepository.new
    repo.create(artist)
  end

  # get '/hello' do
  #   return erb(:hello)
  # end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:albums)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    @album_id = params[:id]
    album = album_repo.find(@album_id)
    @title = album.title
    @release_year = album.release_year
    artist_repo = ArtistRepository.new
    @artist_name = artist_repo.find(album.artist_id).name

    return erb(:hello)
    #test
  end

  get '/artists' do
    artist_repo = ArtistRepository.new
    @artists = artist_repo.all
    return erb(:artists)
  end
  
  get '/artists/:id' do
    artist_repo = ArtistRepository.new
    @artist_id = params[:id]
    artist = artist_repo.find(@artist_id)
    @name = artist.name
    @genre = artist.genre

    return erb(:artist)
  end
end
