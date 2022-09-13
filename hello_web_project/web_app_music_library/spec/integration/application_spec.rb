require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    sql = File.read('./spec/seeds/music_library_test.sql')
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
    connection.exec(sql)
  end

  # context 'POST to /albums' do
  #   it 'creates a new album' do
  #     response = post('/albums', title: 'Voyage', release_year: 2022, artist_id:2)
  #     expect(response.status).to eq 200
  #     response = get('/albums/13')
  #     expect(response.status).to eq 200
  #     album_hash = JSON.parse(response.body)
  #     expect(album_hash["id"]).to eq 13
  #     expect(album_hash["title"]).to eq "Voyage"
  #     expect(album_hash["release_year"]).to eq "2022"
  #     expect(album_hash["artist_id"]).to eq 2
  #   end
  # end

  context 'GET to /artists' do
    it 'Returns as list of artist names as a string' do
      response = get('/artists')
      expect(response.status).to eq 200
      expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone"
    end
  end

  context 'POST to /artists' do
    it 'Creates a new artist' do
      response = post('/artists', name: 'Ed Sheeran', genre: 'Pop')
      expect(response.status).to eq 200
      response = get('/artists')
      expect(response.status).to eq 200
      expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Ed Sheeran"
    end
  end

  # context 'GET to /hello' do
  #   it 'sends hello.erb HTML page' do
  #     response = get('/hello')
  #     expect(response.body).to include('<h1>Hello!</h1>')
  #   end
  # end

  context 'GET to /albums/:id' do
    it "Sends the particular album change" do
      response = get('/albums/1')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

end
